import 'package:blade/container/blade_container.dart';
import 'package:blade/messenger/event_dispatcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../container/blade_container.dart';
import '../container/container_manager.dart';

abstract class BaseNavigator {
  ContainerManager get containerManager;
  BladeContainer get topContainer;
  EventDispatcher get eventDispatcher;

  @protected
  @mustCallSuper
  void init() {
    print('BaseNavigator init');
  }

  String createPageId(String pageName) {
    return Uuid().v4() + '#$pageName';
  }

// Route<dynamic>? _getCurrentPageRoute() {
//   return topContainer.topPage.route;
// }
//
// String _getCurrentPageUniqueId() {
//   return topContainer.topPage.pageInfo.id;
// }
//
// String? _getPreviousPageUniqueId() {
//   assert(topContainer.pages != null);
//   final int pageCount = topContainer.pages.length;
//   if (pageCount > 1) {
//     return topContainer.pages[pageCount - 2].pageInfo.id;
//   } else {
//     final int containerCount = containers.length;
//     if (containerCount > 1) {
//       return containers[containerCount - 2].pages.last.pageInfo.id;
//     }
//   }
//
//   return null;
// }
//
// Route<dynamic>? _getPreviousPageRoute() {
//   final int pageCount = topContainer.pages.length;
//   if (pageCount > 1) {
//     return topContainer.pages[pageCount - 2].route;
//   } else {
//     final int containerCount = containers.length;
//     if (containerCount > 1) {
//       return containers[containerCount - 2].pages.last.route;
//     }
//   }
//
//   return null;
// }

// PageInfo getTopPageInfo() {
//   return topContainer.topPage.pageInfo;
// }
}

