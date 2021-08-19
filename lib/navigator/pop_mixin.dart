import 'dart:io';

import 'package:blade/container/blade_container.dart';
import 'package:blade/messenger/nativeEvents/pop_native_page_event.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import '../logger.dart';

mixin popMixin on BaseNavigator {
  final List<BladeContainer> _pendingPopContainers = <BladeContainer>[];

  void pop<T>({String? id, T? result}) async {
    BladeContainer? container;
    if (id != null) {
      container = containerManager.getContainerById(id);
      if (container == null) {
        return;
      }
    } else {
      container = topContainer;
    }

    if (container != topContainer) {
      return;
    }
    if (container.pages.length > 1) {
      container.pop(result);
    } else {
      popContainer(container, result as Map<String, dynamic>?);
    }

    Logger.log('pop , id=$id, $container');
  }

  Future<void> popUtil<T extends Object>(String id, [T? result]) async {

  }

  void popContainer(BladeContainer container, Map<String, dynamic>? result) async {
    Logger.log('_removeContainer ,  uniqueId=${container.pageInfo.id}');
    containerManager.removeContainer(container);
    _pendingPopContainers.add(container);

    final pageInfo = PageInfo(name: container.pageInfo.name,
        id: container.pageInfo.id,
        arguments:result);
    final popNativePageEvent = PopNativePageEvent(pageInfo);
    eventDispatcher.sendNativeEvent(popNativePageEvent);

    if (Platform.isAndroid) {
      _removeContainer(container.pageInfo.id,
          targetContainers: _pendingPopContainers);
    }
  }

  void _removeContainer(String id, {required List<BladeContainer> targetContainers}) {
    final removedContainer = containerManager.removeContainerById(
        id, targetContainers);
    removedContainer?.detach();
  }
}