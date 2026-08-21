name: UniTrack
description: "UniTrack - Your offline study planner."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  get: ^4.6.6
  flutter_riverpod: ^2.6.1
  sqflite: ^2.4.2
  http: ^1.2.2
  path: ^1.9.1
  path_provider: ^2.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  flutter_launcher_icons: ^0.14.3

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/unitrack_logo.png"
  min_sdk_android: 21
  remove_alpha_ios: true
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/images/unitrack_logo.png"

flutter:
  uses-material-design: true

  assets:
    - assets/images/unitrack_splash.png
    - assets/images/unitrack_logo.png
