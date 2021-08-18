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

  final List<Route<T>> _route = <Route<T>>[];
  Route<T>? get route => _route.isEmpty ? null : _route.first;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'BladePage')}(name:$name, id:${pageInfo.id}, arguments:$arguments)';

  @override
  Route<T> createRoute(BuildContext context) {
    _route.clear();
    _route.add(routeFactory(this, pageInfo.id) as Route<T>);
    return _route.first;
  }
}