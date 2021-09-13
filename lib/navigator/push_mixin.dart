import 'package:blade/container/blade_container.dart';
import 'package:blade/container/overlay_entry.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';

import '../logger.dart';

mixin PushMixin on BaseNavigator {

  void push(PageInfo pageInfo) {
    final id = pageInfo.id;
    final BladeContainer? container = containerManager.getContainerById(id);
    if (container != null) {
      if (topContainer != container) {
        containerManager.removeContainer(container);
        container.entryRemoved();
        containerManager.addContainer(container);
        insertEntry(container);
      } else {
      }
    } else {
      final container = containerManager.createContainer(pageInfo);
      containerManager.addContainer(container);
      insertEntry(container);
    }

    Logger.log('push page,'
        ' id=$id, '
        'existed=$container,'
        'arguments:$pageInfo.arguments');
  }
}