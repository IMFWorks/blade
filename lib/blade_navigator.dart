import 'package:flutter/cupertino.dart';
import 'blade_app.dart';
import 'container/overlay_entry.dart';

abstract class BladeNavigator {

  static BladeNavigator of() {
    BuildContext? context = overlayKey.currentContext;
    if (context != null) {
      BladeAppState? appState;
      appState = context.findAncestorStateOfType<BladeAppState>();
      if (appState != null) {
        return appState.navigator;
      } else {
        throw Exception('appState is null');
      }
    } else {
      throw Exception('overlayKey.currentContext is null');
    }
  }

  Future<T?> pushNativePage<T extends Object>(String name,
      {Map<String, Object>? arguments});

  Future<T?> pushFlutterPageOnNative<T>(String name,
      {Map<String, Object>? arguments});

  Future<T?> pushFlutterPage<T>(String name,
      {Map<String, Object>? arguments});

  void pop<T>({String? id, T? result});

  Future<void> popUtil<T extends Object>(String id, [T? result]);
}

