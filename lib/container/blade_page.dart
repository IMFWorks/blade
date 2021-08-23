import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../messenger/page_info.dart';

typedef BladeRouteFactory = Route<dynamic> Function(
    RouteSettings settings, String uniqueId);

class BladePage<T> extends Page<T> {
  BladePage({LocalKey? key, required this.routeFactory, required this.pageInfo})
      : super(key: key, name: pageInfo.name, arguments: pageInfo.arguments);

  final BladeRouteFactory routeFactory;
  final PageInfo pageInfo;

  static BladePage<T> create<T>(
      PageInfo pageInfo, BladeRouteFactory routeFactory) {
    return BladePage<T>(
        key: UniqueKey(), pageInfo: pageInfo, routeFactory: routeFactory);
  }

  Route<T>? _route;
  Route<T>? get route => _route;

  /// A future that completes when this page is popped.
  Future<T> get popped => _popCompleter.future;
  final Completer<T> _popCompleter = Completer<T>();

  void didComplete(T? result) {
    if (!_popCompleter.isCompleted) {
      _popCompleter.complete(result);
    }
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'BladePage')}(name:$name, id:${pageInfo.id}, arguments:$arguments)';

  @override
  Route<T> createRoute(BuildContext context) {
    final route = (routeFactory(this, pageInfo.id) as Route<T>);
    _route = route;
    return route;
  }
}