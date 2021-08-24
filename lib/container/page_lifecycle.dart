import 'package:flutter/material.dart';

import 'package:blade/logger.dart';

abstract class PageLifecycleObserver {
  void onAppeared();
  void onDisappeared();
  void onForeground() {
  }

  void onBackground() {
  }
}

typedef ObserverCallback = Function(PageLifecycleObserver observer);

class PageLifecycle {
  PageLifecycle._();
  static final PageLifecycle shared = PageLifecycle._();
  final Map<Route<dynamic>, Set<PageLifecycleObserver>> _listeners =
      <Route<dynamic>, Set<PageLifecycleObserver>>{};

  void addObserver(PageLifecycleObserver observer, Route<dynamic> route) {
    final Set<PageLifecycleObserver> observers =
        _listeners.putIfAbsent(route, () => <PageLifecycleObserver>{});
    Logger.log(
        'page_lifecycle, #addObserver, $observers, ${route.settings.name}');
    observers.add(observer);
  }

  void removeObserver(PageLifecycleObserver observer) {
    for (final Route<dynamic> route in _listeners.keys) {
      final Set<PageLifecycleObserver>? observers = _listeners[route];
      observers?.remove(observer);
    }

    _listeners.removeWhere((key, value) => value.isEmpty);
    Logger.log('page_lifecycle, #removeObserver, $observer');
  }

  void dispatchAppearedEvent(Route<dynamic> route) {
    _dispatchEvent(route, (observer) => observer.onAppeared());
    Logger.log(
        'page_lifecycle, #_dispatchAppearedEvent, ${route.settings.name}');
  }

  void dispatchDisappearedEvent(Route<dynamic> route) {
    _dispatchEvent(route, (observer) => observer.onDisappeared());
    Logger.log(
        'page_lifecycle, #dispatchDisappearedEvent, ${route.settings.name}');
  }

  void dispatchForegroundEvent(Route<dynamic> route) {
    _dispatchEvent(route, (observer) => observer.onForeground());
    Logger.log(
        'page_visibility, #dispatchForegroundEvent, ${route.settings.name}');
  }

  void dispatchBackgroundEvent(Route<dynamic> route) {
    _dispatchEvent(route, (observer) => observer.onBackground());
    Logger.log(
        'page_lifecycle, #dispatchBackgroundEvent, ${route.settings.name}');
  }

  void _dispatchEvent(Route<dynamic> route, ObserverCallback callback) {
    final List<PageLifecycleObserver>? observers = _listeners[route]?.toList();
    if (observers != null) {
      for (PageLifecycleObserver observer in observers) {
        try {
          callback(observer);
        } catch (e) {
          Logger.logObject(e);
        }
      }
    }
  }
}




