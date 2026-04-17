import 'dart:io';

import 'package:path/path.dart' as p;

import 'release_metadata.dart';

const _supportedPlatforms = {'web', 'android', 'windows', 'macos', 'linux'};

void main(List<String> args) async {
  final config = _parseArgs(args);
  if (config == null) {
    _printUsage();
    exitCode = 64;
    return;
  }

  final projectDir = Directory.current;
  final source = _resolveSource(projectDir, config);
  if (source == null || !source.existsSync()) {
    stderr.writeln('未找到待打包产物: ${source?.path ?? 'unknown'}');
    exitCode = 1;
    return;
  }

  final version = _readVersion(projectDir) ?? '0.0.0';
  final releaseDir = Directory(
    '${projectDir.path}${Platform.pathSeparator}release'
    '${Platform.pathSeparator}${config.platform}'
    '${Platform.pathSeparator}${config.profile}'
    '${config.arch == null ? '' : '${Platform.pathSeparator}${config.arch}'}',
  )..createSync(recursive: true);

  final baseName = [
    ReleaseMetadata.executableName,
    version,
    config.platform,
    if (config.arch != null && config.arch!.isNotEmpty) config.arch!,
  ].join('-');

  final packaged =
      await _package(source, releaseDir, baseName, config.platform);
  stdout.writeln('发布包已输出到:');
  for (final item in packaged) {
    stdout.writeln('  - ${item.path}');
  }
}

_PackageConfig? _parseArgs(List<String> args) {
  if (args.isEmpty) return null;
  final platform = args.first.trim().toLowerCase();
  if (!_supportedPlatforms.contains(platform)) {
    stderr.writeln('不支持的平台: $platform');
    return null;
  }

  String profile = 'prod';
  String? arch;
  for (var i = 1; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--help' || arg == '-h') {
      return null;
    }
    if (arg.startsWith('--profile=')) {
      profile = arg.substring('--profile='.length).trim().toLowerCase();
      continue;
    }
    if (arg == '--profile' && i + 1 < args.length) {
      profile = args[++i].trim().toLowerCase();
      continue;
    }
    if (arg.startsWith('--arch=')) {
      arch = arg.substring('--arch='.length).trim().toLowerCase();
      continue;
    }
    if (arg == '--arch' && i + 1 < args.length) {
      arch = args[++i].trim().toLowerCase();
      continue;
    }
    stderr.writeln('无法识别的参数: $arg');
    return null;
  }

  return _PackageConfig(platform: platform, profile: profile, arch: arch);
}

FileSystemEntity? _resolveSource(Directory projectDir, _PackageConfig config) {
  final path = [
    projectDir.path,
    'dist',
    config.platform,
    config.profile,
    if (config.arch != null && config.arch!.isNotEmpty) config.arch!,
  ].join(Platform.pathSeparator);
  final dir = Directory(path);
  if (!dir.existsSync()) return null;

  if (config.platform == 'android') {
    final apks = dir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.apk'))
        .toList();
    if (apks.isEmpty) return null;
    if (apks.length == 1) return apks.first;
  }
  return dir;
}

String? _readVersion(Directory projectDir) {
  final pubspec =
      File('${projectDir.path}${Platform.pathSeparator}pubspec.yaml');
  if (!pubspec.existsSync()) return null;
  for (final line in pubspec.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.startsWith('version:')) {
      final raw = trimmed.substring('version:'.length).trim();
      return raw.split('+').first;
    }
  }
  return null;
}

Future<List<FileSystemEntity>> _package(
  FileSystemEntity source,
  Directory releaseDir,
  String baseName,
  String platform,
) async {
  if (source is File) {
    final ext = source.path.split('.').last;
    final target =
        File('${releaseDir.path}${Platform.pathSeparator}$baseName.$ext');
    source.copySync(target.path);
    return [target];
  }

  final directory = source as Directory;

  return switch (platform) {
    'web' => _packageWeb(directory, releaseDir, baseName),
    'windows' => _packageWindows(directory, releaseDir, baseName),
    'macos' => _packageMacos(directory, releaseDir, baseName),
    'linux' => _packageLinux(directory, releaseDir, baseName),
    _ => _packageDirectoryAsZip(directory, releaseDir, baseName),
  };
}

Future<List<FileSystemEntity>> _packageWeb(
  Directory source,
  Directory releaseDir,
  String baseName,
) async {
  final zip = await _zipDirectory(source, releaseDir, baseName);
  return [zip];
}

Future<List<FileSystemEntity>> _packageWindows(
  Directory source,
  Directory releaseDir,
  String baseName,
) async {
  final outputs = <FileSystemEntity>[];
  outputs.add(await _zipDirectory(source, releaseDir, baseName));

  final iscc = _findCommand(['iscc', 'ISCC.exe']);
  if (iscc != null) {
    outputs
        .add(await _buildWindowsInstaller(source, releaseDir, baseName, iscc));
  }
  return outputs;
}

Future<List<FileSystemEntity>> _packageMacos(
  Directory source,
  Directory releaseDir,
  String baseName,
) async {
  final outputs = <FileSystemEntity>[];
  outputs.add(await _zipDirectory(source, releaseDir, baseName));

  final app = source
      .listSync()
      .whereType<Directory>()
      .firstWhere((item) => item.path.endsWith('.app'));
  if (_findCommand(['hdiutil']) != null) {
    outputs.add(await _buildMacosDmg(app, releaseDir, baseName));
  }
  return outputs;
}

Future<List<FileSystemEntity>> _packageLinux(
  Directory source,
  Directory releaseDir,
  String baseName,
) async {
  final outputs = <FileSystemEntity>[];
  outputs.add(await _buildTarGz(source, releaseDir, baseName));

  final dpkgDeb = _findCommand(['dpkg-deb']);
  if (dpkgDeb != null) {
    outputs.add(await _buildLinuxDeb(source, releaseDir, baseName, dpkgDeb));
  }

  final rpmBuild = _findCommand(['rpmbuild']);
  if (rpmBuild != null) {
    outputs.add(await _buildLinuxRpm(source, releaseDir, baseName, rpmBuild));
  }

  final appImageTool =
      _findCommand(['appimagetool', 'appimagetool-x86_64.AppImage']);
  if (appImageTool != null) {
    outputs.add(
        await _buildLinuxAppImage(source, releaseDir, baseName, appImageTool));
  }

  return outputs;
}

Future<List<FileSystemEntity>> _packageDirectoryAsZip(
  Directory source,
  Directory releaseDir,
  String baseName,
) async {
  final zip = await _zipDirectory(source, releaseDir, baseName);
  return [zip];
}

Future<File> _zipDirectory(
  Directory source,
  Directory releaseDir,
  String baseName,
) async {
  final target =
      File('${releaseDir.path}${Platform.pathSeparator}$baseName.zip');
  if (Platform.isWindows) {
    await _run(
      'powershell',
      [
        '-NoProfile',
        '-Command',
        'Compress-Archive -Path "${source.path}\\*" -DestinationPath "${target.path}" -Force',
      ],
    );
    return target;
  }

  if (_findCommand(['ditto']) != null) {
    await _run(
      'ditto',
      ['-c', '-k', '--sequesterRsrc', '--keepParent', source.path, target.path],
    );
    return target;
  }

  await _run('zip', ['-r', target.path, '.'], workingDirectory: source.path);
  return target;
}

Future<File> _buildTarGz(
  Directory source,
  Directory releaseDir,
  String baseName,
) async {
  final target =
      File('${releaseDir.path}${Platform.pathSeparator}$baseName.tar.gz');
  await _run(
    'tar',
    [
      '-czf',
      target.path,
      '-C',
      source.parent.path,
      source.uri.pathSegments[source.uri.pathSegments.length - 2],
    ],
    workingDirectory: source.parent.path,
  );
  return target;
}

Future<File> _buildWindowsInstaller(
  Directory source,
  Directory releaseDir,
  String baseName,
  String iscc,
) async {
  final script =
      File('${releaseDir.path}${Platform.pathSeparator}$baseName.iss');
  final version = baseName.split('-')[1];
  final outputName = '$baseName-setup';
  script.writeAsStringSync('''
#define MyAppName "${ReleaseMetadata.displayName}"
#define MyAppVersion "$version"
#define MyAppPublisher "${ReleaseMetadata.publisher}"
#define MyAppExeName "${ReleaseMetadata.windowsExeName}"

[Setup]
AppId={{${ReleaseMetadata.windowsExeName}}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=${releaseDir.path.replaceAll(r'\', r'\\')}
OutputBaseFilename=$outputName
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "simplifiedchinese"; MessagesFile: "compiler:Languages\\ChineseSimplified.isl"

[Files]
Source: "${source.path.replaceAll(r'\', r'\\')}\\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\\{#MyAppName}"; Filename: "{app}\\{#MyAppExeName}"
Name: "{autodesktop}\\{#MyAppName}"; Filename: "{app}\\{#MyAppExeName}"

[Run]
Filename: "{app}\\{#MyAppExeName}"; Description: "启动 {#MyAppName}"; Flags: nowait postinstall skipifsilent
''');
  await _run(iscc, [script.path]);
  return File('${releaseDir.path}${Platform.pathSeparator}$outputName.exe');
}

Future<File> _buildMacosDmg(
  Directory app,
  Directory releaseDir,
  String baseName,
) async {
  final dmg = File('${releaseDir.path}${Platform.pathSeparator}$baseName.dmg');
  final stageDir =
      Directory('${releaseDir.path}${Platform.pathSeparator}.dmg_stage');
  if (stageDir.existsSync()) {
    stageDir.deleteSync(recursive: true);
  }
  stageDir.createSync(recursive: true);
  _copyDirectory(app, Directory(p.join(stageDir.path, p.basename(app.path))));
  await _run(
    'hdiutil',
    [
      'create',
      '-volname',
      ReleaseMetadata.displayName,
      '-srcfolder',
      stageDir.path,
      '-ov',
      '-format',
      'UDZO',
      dmg.path,
    ],
  );
  stageDir.deleteSync(recursive: true);
  return dmg;
}

Future<File> _buildLinuxDeb(
  Directory source,
  Directory releaseDir,
  String baseName,
  String dpkgDeb,
) async {
  final packageRoot =
      Directory('${releaseDir.path}${Platform.pathSeparator}.deb_pkg');
  if (packageRoot.existsSync()) {
    packageRoot.deleteSync(recursive: true);
  }
  packageRoot.createSync(recursive: true);

  final appLibDir = Directory(
    p.join(packageRoot.path, 'usr', 'lib', ReleaseMetadata.executableName),
  )..createSync(recursive: true);
  _copyDirectory(source, appLibDir);

  final binDir = Directory(p.join(packageRoot.path, 'usr', 'bin'))
    ..createSync(recursive: true);
  final launcher = File(p.join(binDir.path, ReleaseMetadata.executableName));
  launcher.writeAsStringSync('''
#!/bin/sh
exec /usr/lib/${ReleaseMetadata.executableName}/${ReleaseMetadata.executableName} "\$@"
''');
  await _makeExecutable(launcher);

  final applicationsDir = Directory(
    p.join(packageRoot.path, 'usr', 'share', 'applications'),
  )..createSync(recursive: true);
  File(p.join(applicationsDir.path,
          '${ReleaseMetadata.linuxApplicationId}.desktop'))
      .writeAsStringSync('''
[Desktop Entry]
Name=${ReleaseMetadata.displayName}
Comment=${ReleaseMetadata.description}
Exec=${ReleaseMetadata.executableName}
Icon=${ReleaseMetadata.linuxApplicationId}
Terminal=false
Type=Application
Categories=Office;Utility;
StartupNotify=true
''');

  final iconDir = Directory(
    p.join(packageRoot.path, 'usr', 'share', 'icons', 'hicolor', '256x256',
        'apps'),
  )..createSync(recursive: true);
  final iconSource = _releaseIconSource();
  if (iconSource.existsSync()) {
    iconSource.copySync(
      p.join(iconDir.path, '${ReleaseMetadata.linuxApplicationId}.png'),
    );
  }

  final debianDir = Directory(p.join(packageRoot.path, 'DEBIAN'))
    ..createSync(recursive: true);
  File(p.join(debianDir.path, 'control')).writeAsStringSync('''
Package: ${ReleaseMetadata.executableName.replaceAll('_', '-')}
Version: ${baseName.split('-')[1]}
Section: utils
Priority: optional
Architecture: amd64
Maintainer: ${ReleaseMetadata.publisher}
Description: ${ReleaseMetadata.description}
''');

  final target =
      File('${releaseDir.path}${Platform.pathSeparator}$baseName.deb');
  await _run(dpkgDeb, ['--build', packageRoot.path, target.path]);
  packageRoot.deleteSync(recursive: true);
  return target;
}

Future<File> _buildLinuxAppImage(
  Directory source,
  Directory releaseDir,
  String baseName,
  String appImageTool,
) async {
  final appDir =
      Directory('${releaseDir.path}${Platform.pathSeparator}.AppDir');
  if (appDir.existsSync()) {
    appDir.deleteSync(recursive: true);
  }
  final usrBin = Directory(p.join(appDir.path, 'usr', 'bin'))
    ..createSync(recursive: true);
  final usrLib = Directory(
    p.join(appDir.path, 'usr', 'lib', ReleaseMetadata.executableName),
  )..createSync(recursive: true);
  _copyDirectory(source, usrLib);

  final usrLauncher = File(p.join(usrBin.path, ReleaseMetadata.executableName));
  usrLauncher.writeAsStringSync(
    [
      '#!/bin/sh',
      r'HERE="$(dirname "$(readlink -f "$0")")"',
      r'exec "$HERE/../lib/' +
          '${ReleaseMetadata.executableName}/${ReleaseMetadata.executableName}' +
          r'" "$@"',
      '',
    ].join('\n'),
  );
  await _makeExecutable(usrLauncher);

  final desktopFile = File(
    p.join(appDir.path, '${ReleaseMetadata.linuxApplicationId}.desktop'),
  )..writeAsStringSync('''
[Desktop Entry]
Name=${ReleaseMetadata.displayName}
Comment=${ReleaseMetadata.description}
Exec=${ReleaseMetadata.executableName}
Icon=${ReleaseMetadata.linuxApplicationId}
Terminal=false
Type=Application
Categories=Office;Utility;
''');
  if (!desktopFile.existsSync()) {
    throw StateError('AppImage desktop file generation failed');
  }

  final appRun = File(p.join(appDir.path, 'AppRun'))
    ..writeAsStringSync(
      [
        '#!/bin/sh',
        r'HERE="$(dirname "$(readlink -f "$0")")"',
        r'exec "$HERE/usr/bin/' + ReleaseMetadata.executableName + r'" "$@"',
        '',
      ].join('\n'),
    );
  await _makeExecutable(appRun);

  final iconSource = _releaseIconSource();
  if (iconSource.existsSync()) {
    iconSource.copySync(
      p.join(appDir.path, '${ReleaseMetadata.linuxApplicationId}.png'),
    );
  }

  final target =
      File('${releaseDir.path}${Platform.pathSeparator}$baseName.AppImage');
  final env = Map<String, String>.from(Platform.environment)
    ..putIfAbsent('ARCH', () => 'x86_64');
  await _run(appImageTool, [appDir.path, target.path], environment: env);
  appDir.deleteSync(recursive: true);
  return target;
}

Future<File> _buildLinuxRpm(
  Directory source,
  Directory releaseDir,
  String baseName,
  String rpmBuild,
) async {
  final version = baseName.split('-')[1];
  final rpmRoot =
      Directory('${releaseDir.path}${Platform.pathSeparator}.rpmroot');
  if (rpmRoot.existsSync()) {
    rpmRoot.deleteSync(recursive: true);
  }

  final buildRoot = Directory(p.join(rpmRoot.path, 'BUILDROOT'));
  final rpmsDir = Directory(p.join(rpmRoot.path, 'RPMS'));
  final sourcesDir = Directory(p.join(rpmRoot.path, 'SOURCES'));
  final specsDir = Directory(p.join(rpmRoot.path, 'SPECS'));
  final srpmsDir = Directory(p.join(rpmRoot.path, 'SRPMS'));
  final buildDir = Directory(p.join(rpmRoot.path, 'BUILD'));
  for (final dir in [
    buildRoot,
    rpmsDir,
    sourcesDir,
    specsDir,
    srpmsDir,
    buildDir
  ]) {
    dir.createSync(recursive: true);
  }

  final packageRoot = Directory(
    p.join(buildRoot.path,
        '${ReleaseMetadata.executableName.replaceAll('_', '-')}-${version}-1.x86_64'),
  )..createSync(recursive: true);

  final appLibDir = Directory(
    p.join(packageRoot.path, 'usr', 'lib', ReleaseMetadata.executableName),
  )..createSync(recursive: true);
  _copyDirectory(source, appLibDir);

  final binDir = Directory(p.join(packageRoot.path, 'usr', 'bin'))
    ..createSync(recursive: true);
  final launcher = File(p.join(binDir.path, ReleaseMetadata.executableName));
  launcher.writeAsStringSync('''
#!/bin/sh
exec /usr/lib/${ReleaseMetadata.executableName}/${ReleaseMetadata.executableName} "\$@"
''');
  await _makeExecutable(launcher);

  final applicationsDir = Directory(
    p.join(packageRoot.path, 'usr', 'share', 'applications'),
  )..createSync(recursive: true);
  File(p.join(applicationsDir.path,
          '${ReleaseMetadata.linuxApplicationId}.desktop'))
      .writeAsStringSync('''
[Desktop Entry]
Name=${ReleaseMetadata.displayName}
Comment=${ReleaseMetadata.description}
Exec=${ReleaseMetadata.executableName}
Icon=${ReleaseMetadata.linuxApplicationId}
Terminal=false
Type=Application
Categories=Office;Utility;
StartupNotify=true
''');

  final iconDir = Directory(
    p.join(packageRoot.path, 'usr', 'share', 'icons', 'hicolor', '256x256',
        'apps'),
  )..createSync(recursive: true);
  final iconSource = _releaseIconSource();
  if (iconSource.existsSync()) {
    iconSource.copySync(
      p.join(iconDir.path, '${ReleaseMetadata.linuxApplicationId}.png'),
    );
  }

  final spec =
      File(p.join(specsDir.path, '${ReleaseMetadata.executableName}.spec'));
  spec.writeAsStringSync('''
Name: ${ReleaseMetadata.executableName.replaceAll('_', '-')}
Version: $version
Release: 1%{?dist}
Summary: ${ReleaseMetadata.description}
License: Proprietary
URL: https://example.com
BuildArch: x86_64

%description
${ReleaseMetadata.description}

%install
mkdir -p %{buildroot}
cp -a ${packageRoot.path}/. %{buildroot}/

%files
/usr/bin/${ReleaseMetadata.executableName}
/usr/lib/${ReleaseMetadata.executableName}
/usr/share/applications/${ReleaseMetadata.linuxApplicationId}.desktop
/usr/share/icons/hicolor/256x256/apps/${ReleaseMetadata.linuxApplicationId}.png
''');

  await _run(
    rpmBuild,
    [
      '--define',
      '_topdir ${rpmRoot.path}',
      '--buildroot',
      packageRoot.path,
      '-bb',
      spec.path,
    ],
  );

  final rpmFile = rpmsDir
      .listSync(recursive: true)
      .whereType<File>()
      .firstWhere((file) => file.path.endsWith('.rpm'));
  final target =
      File('${releaseDir.path}${Platform.pathSeparator}$baseName.rpm');
  rpmFile.copySync(target.path);
  rpmRoot.deleteSync(recursive: true);
  return target;
}

File _releaseIconSource() {
  return File(
    p.join(
      Directory.current.path,
      'macos',
      'Runner',
      'Assets.xcassets',
      'AppIcon.appiconset',
      'app_icon_256.png',
    ),
  );
}

void _copyDirectory(Directory source, Directory destination) {
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }
  for (final entity in source.listSync(recursive: false)) {
    final targetPath =
        '${destination.path}${Platform.pathSeparator}${entity.uri.pathSegments.last}';
    if (entity is Directory) {
      _copyDirectory(entity, Directory(targetPath));
    } else if (entity is File) {
      entity.copySync(targetPath);
    }
  }
}

Future<void> _makeExecutable(File file) async {
  if (Platform.isWindows) return;
  await _run('chmod', ['755', file.path]);
}

Future<void> _run(
  String command,
  List<String> args, {
  String? workingDirectory,
  Map<String, String>? environment,
}) async {
  final result = await Process.run(
    command,
    args,
    workingDirectory: workingDirectory,
    environment: environment,
  );
  if (result.exitCode != 0) {
    throw ProcessException(
      command,
      args,
      '${result.stdout}\n${result.stderr}',
      result.exitCode,
    );
  }
}

String? _findCommand(List<String> candidates) {
  for (final candidate in candidates) {
    final result =
        Process.runSync(Platform.isWindows ? 'where' : 'which', [candidate]);
    if (result.exitCode == 0) {
      final first = (result.stdout as String)
          .trim()
          .split(RegExp(r'[\r\n]+'))
          .firstWhere((line) => line.trim().isNotEmpty, orElse: () => '');
      if (first.isNotEmpty) return first;
    }
  }
  return null;
}

void _printUsage() {
  stdout.writeln('''
统一发布归档入口

用法:
  dart run tool/package_release.dart <platform> [options]

选项:
  --profile <dev|test|staging|prod>   默认 prod
  --arch <arm64|amd64|arm32|x64>      与 dist 目录层级对应

示例:
  dart run tool/package_release.dart web --profile prod
  dart run tool/package_release.dart android --profile prod --arch arm64
  dart run tool/package_release.dart windows --profile prod
  dart run tool/package_release.dart macos --profile prod
  dart run tool/package_release.dart linux --profile prod --arch amd64

说明:
  - windows: 生成 zip，若系统存在 Inno Setup(ISCC) 则额外生成安装包 exe
  - macos: 生成 zip，若系统存在 hdiutil 则额外生成 dmg
  - linux: 生成 tar.gz，若系统存在 dpkg-deb 则额外生成 deb，
           若系统存在 rpmbuild 则额外生成 rpm，
           若系统存在 appimagetool 则额外生成 AppImage
''');
}

class _PackageConfig {
  const _PackageConfig({
    required this.platform,
    required this.profile,
    required this.arch,
  });

  final String platform;
  final String profile;
  final String? arch;
}
