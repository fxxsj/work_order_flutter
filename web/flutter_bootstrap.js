{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  onEntrypointLoaded: function (engineInitializer) {
    engineInitializer.initializeEngine().then(function (appRunner) {
      window.dispatchEvent(new Event("flutter-app-run"));
      return appRunner.runApp();
    });
  },
});
