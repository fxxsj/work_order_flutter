import 'dart:io';

const _supportedPlatforms = {'web', 'android', 'windows', 'macos', 'linux'};
const _supportedProfiles = {'dev', 'test', 'staging', 'prod'};
const _supportedArchs = {'arm64', 'amd64', 'arm32', 'x64'};

void main(List<String> args) async {
  final config = _parseArgs(args);
  if (config == null) {
    _printUsage();
    exitCode = 64;
    return;
  }

  final projectDir = Directory.current;
  final flutterRoot =
      Directory('${projectDir.path}${Platform.pathSeparator}build');
  if (!projectDir.existsSync()) {
    stderr.writeln('项目目录不存在');
    exitCode = 2;
    return;
  }

  final command = _buildCommand(config);
  stdout.writeln('> ${command.join(' ')}');

  final process = await Process.start(
    command.first,
    command.skip(1).toList(),
    workingDirectory: projectDir.path,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) {
    exitCode = code;
    return;
  }

  final artifact = _resolveArtifact(projectDir, config);
  if (artifact == null || !artifact.existsSync()) {
    stderr.writeln('构建完成，但未找到预期产物: ${artifact?.path ?? 'unknown'}');
    exitCode = 1;
    return;
  }

  final distDir = Directory(
    '${projectDir.path}${Platform.pathSeparator}dist'
    '${Platform.pathSeparator}${config.platform}'
    '${Platform.pathSeparator}${config.profile}'
    '${config.arch == null ? '' : '${Platform.pathSeparator}${config.arch}'}',
  );
  if (distDir.existsSync()) {
    distDir.deleteSync(recursive: true);
  }
  distDir.createSync(recursive: true);

  if (artifact is File) {
    final target = File(
      '${distDir.path}${Platform.pathSeparator}${artifact.uri.pathSegments.last}',
    );
    artifact.copySync(target.path);
    stdout.writeln('产物已输出到: ${target.path}');
  } else if (artifact is Directory) {
    _copyDirectory(artifact, distDir);
    stdout.writeln('产物已输出到: ${distDir.path}');
  }

  if (_isDesktopPlatform(config.platform) && config.arch != null) {
    stdout.writeln(
      '提示: ${config.platform} 当前按宿主机构建。--arch=${config.arch} 仅用于产物目录标识，'
      '实际目标架构仍取决于构建机器与 Flutter 平台支持。',
    );
  }

  if (config.platform == 'android' && config.arch == null) {
    stdout.writeln('提示: Android 未指定 --arch，当前输出为默认 APK 产物。');
  }

  if (flutterRoot.existsSync()) {
    // no-op: keep variable used to make future expansion simpler
  }
}

_BuildConfig? _parseArgs(List<String> args) {
  if (args.isEmpty) return null;

  final platform = args.first.trim().toLowerCase();
  if (!_supportedPlatforms.contains(platform)) {
    stderr.writeln('不支持的平台: $platform');
    return null;
  }

  String profile = 'prod';
  String? arch;
  String? apiBaseUrl;
  String displayName = '新西彩订单管理';

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
    if (arg.startsWith('--api-base-url=')) {
      apiBaseUrl = arg.substring('--api-base-url='.length).trim();
      continue;
    }
    if (arg == '--api-base-url' && i + 1 < args.length) {
      apiBaseUrl = args[++i].trim();
      continue;
    }
    if (arg.startsWith('--display-name=')) {
      displayName = arg.substring('--display-name='.length).trim();
      continue;
    }
    if (arg == '--display-name' && i + 1 < args.length) {
      displayName = args[++i].trim();
      continue;
    }
    stderr.writeln('无法识别的参数: $arg');
    return null;
  }

  if (!_supportedProfiles.contains(profile)) {
    stderr.writeln('不支持的环境: $profile');
    return null;
  }

  if (arch != null && !_supportedArchs.contains(arch)) {
    stderr.writeln('不支持的架构: $arch');
    return null;
  }

  if (profile == 'prod' && (apiBaseUrl?.isEmpty ?? true)) {
    stderr.writeln('prod 构建必须显式传入 --api-base-url');
    return null;
  }

  return _BuildConfig(
    platform: platform,
    profile: profile,
    arch: arch,
    apiBaseUrl: apiBaseUrl,
    displayName: displayName,
  );
}

List<String> _buildCommand(_BuildConfig config) {
  final command = <String>['flutter', 'build'];
  switch (config.platform) {
    case 'web':
      command.addAll(['web', '--release']);
      break;
    case 'android':
      command.addAll(['apk', '--release']);
      if (config.arch != null) {
        final targetPlatform = switch (config.arch) {
          'arm64' => 'android-arm64',
          'arm32' => 'android-arm',
          'x64' || 'amd64' => 'android-x64',
          _ => null,
        };
        if (targetPlatform != null) {
          command
              .addAll(['--target-platform', targetPlatform, '--split-per-abi']);
        }
      }
      break;
    case 'windows':
      command.addAll(['windows', '--release']);
      break;
    case 'macos':
      command.addAll(['macos', '--release']);
      break;
    case 'linux':
      command.addAll(['linux', '--release']);
      break;
  }

  command.addAll([
    '--dart-define=APP_PROFILE=${config.profile}',
    '--dart-define=APP_DISPLAY_NAME=${config.displayName}',
  ]);
  if (config.apiBaseUrl != null && config.apiBaseUrl!.isNotEmpty) {
    command.add('--dart-define=APP_API_BASE_URL=${config.apiBaseUrl!}');
  }
  return command;
}

FileSystemEntity? _resolveArtifact(Directory projectDir, _BuildConfig config) {
  final p = projectDir.path;
  switch (config.platform) {
    case 'web':
      return Directory(
          '$p${Platform.pathSeparator}build${Platform.pathSeparator}web');
    case 'android':
      if (config.arch != null) {
        final abi = switch (config.arch) {
          'arm64' => 'arm64-v8a',
          'arm32' => 'armeabi-v7a',
          'x64' || 'amd64' => 'x86_64',
          _ => null,
        };
        if (abi != null) {
          return File(
            '$p${Platform.pathSeparator}build${Platform.pathSeparator}app'
            '${Platform.pathSeparator}outputs${Platform.pathSeparator}flutter-apk'
            '${Platform.pathSeparator}app-$abi-release.apk',
          );
        }
      }
      return File(
        '$p${Platform.pathSeparator}build${Platform.pathSeparator}app'
        '${Platform.pathSeparator}outputs${Platform.pathSeparator}flutter-apk'
        '${Platform.pathSeparator}app-release.apk',
      );
    case 'windows':
      return Directory(
        '$p${Platform.pathSeparator}build${Platform.pathSeparator}windows'
        '${Platform.pathSeparator}x64${Platform.pathSeparator}runner'
        '${Platform.pathSeparator}Release',
      );
    case 'macos':
      return Directory(
        '$p${Platform.pathSeparator}build${Platform.pathSeparator}macos'
        '${Platform.pathSeparator}Build${Platform.pathSeparator}Products'
        '${Platform.pathSeparator}Release',
      );
    case 'linux':
      return Directory(
        '$p${Platform.pathSeparator}build${Platform.pathSeparator}linux'
        '${Platform.pathSeparator}x64${Platform.pathSeparator}release'
        '${Platform.pathSeparator}bundle',
      );
  }
  return null;
}

bool _isDesktopPlatform(String platform) =>
    platform == 'windows' || platform == 'macos' || platform == 'linux';

void _copyDirectory(Directory source, Directory destination) {
  for (final entity in source.listSync(recursive: false)) {
    final targetPath =
        '${destination.path}${Platform.pathSeparator}${entity.uri.pathSegments.last}';
    if (entity is Directory) {
      final dir = Directory(targetPath)..createSync(recursive: true);
      _copyDirectory(entity, dir);
    } else if (entity is File) {
      entity.copySync(targetPath);
    }
  }
}

void _printUsage() {
  stdout.writeln('''
统一构建入口

用法:
  dart run tool/build.dart <platform> [options]

平台:
  web | android | windows | macos | linux

选项:
  --profile <dev|test|staging|prod>   默认 prod
  --arch <arm64|amd64|arm32|x64>      可选，Android 会映射到 target-platform
  --api-base-url <url>                prod 构建必填
  --display-name <name>               默认 新西彩订单管理

示例:
  dart run tool/build.dart web --profile prod --api-base-url https://api.example.com/api/v1/
  dart run tool/build.dart android --profile prod --arch arm64 --api-base-url https://api.example.com/api/v1/
  dart run tool/build.dart windows --profile prod --arch amd64 --api-base-url https://api.example.com/api/v1/
  dart run tool/build.dart macos --profile prod --arch arm64 --api-base-url https://api.example.com/api/v1/
  dart run tool/build.dart linux --profile prod --arch amd64 --api-base-url https://api.example.com/api/v1/
''');
}

class _BuildConfig {
  const _BuildConfig({
    required this.platform,
    required this.profile,
    required this.arch,
    required this.apiBaseUrl,
    required this.displayName,
  });

  final String platform;
  final String profile;
  final String? arch;
  final String? apiBaseUrl;
  final String displayName;
}
