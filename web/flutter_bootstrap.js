{{flutter_js}}
{{flutter_build_config}}
const searchParams = new URLSearchParams(window.location.search);
const host = window.location.hostname || '';
const isLocalDebugHost =
  host === 'localhost' ||
  host === '127.0.0.1' ||
  host === '0.0.0.0';

const cpuOnlyParam = searchParams.get('cpuOnly');
const shouldForceCpuOnly =
  cpuOnlyParam === '1' ||
  cpuOnlyParam === 'true' ||
  (cpuOnlyParam == null && isLocalDebugHost);

const rendererParam = searchParams.get('renderer');
const loaderConfig = {};

// Let Flutter choose the default renderer unless explicitly overridden.
// CanvasKit-specific tuning remains opt-in through the renderer URL param.
if (rendererParam) {
  loaderConfig.renderer = rendererParam;
}

if (shouldForceCpuOnly && loaderConfig.renderer === 'canvaskit') {
  loaderConfig.canvasKitForceCpuOnly = true;
  loaderConfig.canvasKitMaximumSurfaces = 1;
}

_flutter.loader.load({
  config: loaderConfig,
  onEntrypointLoaded: function (engineInitializer) {
    engineInitializer.initializeEngine().then(function (appRunner) {
      window.dispatchEvent(new Event("flutter-app-run"));
      return appRunner.runApp();
    });
  },
});
