{{flutter_js}}
{{flutter_build_config}}


_flutter.loader.load({
  // make flutter web to use [canvasKit] files on local files instead of [gstatic.com]
  config: {
    "canvasKitBaseUrl": "/canvaskit"
  },
});
