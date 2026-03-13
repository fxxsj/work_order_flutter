{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  onEntrypointLoaded: function (engineInitializer) {
    function runWithRenderer(renderer) {
      return engineInitializer
        .initializeEngine({ renderer: renderer })
        .then(function (appRunner) {
          window.dispatchEvent(new Event("flutter-app-run"));
          return appRunner.runApp();
        });
    }

    runWithRenderer("html").catch(function (error) {
      console.warn("HTML renderer failed, falling back to CanvasKit.", error);
      return runWithRenderer("canvaskit");
    });
  },
});
