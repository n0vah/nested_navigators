import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'dart:io';

import 'app.dart';

void main() {
  _setTargetPlatformForDesktop();
  runApp(App());
}

void _setTargetPlatformForDesktop() {
  try {
    TargetPlatform targetPlatform;
    if (Platform.isMacOS) {
      targetPlatform = TargetPlatform.iOS;
    } else if (Platform.isLinux || Platform.isWindows) {
      targetPlatform = TargetPlatform.android;
    }
    if (targetPlatform != null) {
      debugDefaultTargetPlatformOverride = targetPlatform;
    }
  } catch (e) {
    print('Error Setting Target: $e');
  }
}
