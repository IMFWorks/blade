
import 'package:blade/messenger/event_sender.dart';
import 'package:blade/messenger/page_info.dart';

import '../logger.dart';
import 'blade_container.dart';
import 'blade_page.dart';

class ContainerManager {
  final _containers = <BladeContainer>[];
  List<BladeContainer> get containers => _containers;
  BladeContainer get topContainer => containers.last;
  BladeRouteFactory routeFactory;

  ContainerManager(this.routeFactory);

  BladeContainer createContainer(PageInfo pageInfo, EventSender eventSender) {
    return BladeContainer(routeFactory, pageInfo, eventSender);
  }

  BladeContainer? getContainerById(String id) {
    try {
      return containers.reversed.firstWhere((BladeContainer element) =>
          element.pages.any((BladePage<dynamic> element) =>
          element.pageInfo.id == id));
    } catch (e) {
      Logger.logObject(e);
    }
    return null;
  }

  BladeContainer? getContainerByName(String name) {
    try {
      return containers.reversed.firstWhere((element) =>
        element.pages.any((BladePage<dynamic> page) =>
        page.pageInfo.name == name));
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
}