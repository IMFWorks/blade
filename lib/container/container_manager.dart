
import 'package:blade/messenger/page_info.dart';
import 'package:flutter/cupertino.dart';

import '../logger.dart';
import 'blade_container.dart';
import 'blade_page.dart';

class ContainerManager {
  final List<BladeContainer> _containers = <BladeContainer>[];
  List<BladeContainer> get containers => _containers;
  BladeContainer get topContainer => containers.last;

  BladeRouteFactory routeFactory;

  ContainerManager(this.routeFactory) {
  }

  BladeContainer createContainer(PageInfo pageInfo) {
    return BladeContainer(
        key: ValueKey<String>(pageInfo.id),
        pageInfo: pageInfo,
        routeFactory: routeFactory);
  }

  BladeContainer? getContainerById(String id) {
    return _getContainer(_containers, id);
  }

  String? getIdByName(String pageName) {
    try {
      return containers
          .firstWhere((element) =>
      element.pageInfo.name == pageName ||
          element.pages
              .any((element) => element.pageInfo.name == pageName))
          .pageInfo
          .id;
    } catch (e) {
      Logger.logObject(e);
    }
    return null;
  }

  BladeContainer? _getContainer(List<BladeContainer> containers, String id) {
    try {
      return containers.singleWhere((BladeContainer element) =>
      (element.pageInfo.id == id) ||
          element.pages.any((BladePage<dynamic> element) =>
          element.pageInfo.id == id));
    } catch (e) {
      Logger.logObject(e);
    }
    return null;
  }

  void addContainer(BladeContainer container) {
    containers.add(container);
  }

  void removeContainer(BladeContainer container) {
    containers.remove(container);
  }

  BladeContainer? removeContainerById(String id, List<BladeContainer> targetContainers) {
    BladeContainer? container = _getContainer(targetContainers, id);
    if (container != null) {
      targetContainers.remove(container);
    }

    return container;
  }

  // void detachContainer(BladeContainer container) {
  //   Route<dynamic>? route = container.pages.first.route;
  //   //PageVisibilityBinding.instance.dispatchPageDestoryEvent(route);
  //   container.detach();
  // }
}