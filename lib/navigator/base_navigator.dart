import 'package:blade/container/blade_container.dart';
import 'package:blade/messenger/event_dispatcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../container/blade_container.dart';
import '../container/container_manager.dart';
import 'core/raw_stack.dart';

abstract class BaseNavigator {
  ContainerManager get containerManager;
  BladeContainer get topContainer;
  EventDispatcher get eventDispatcher;
  RawStack get rawStack;

  @protected
  @mustCallSuper
  void init() {
    print('BaseNavigator init');
  }

  String createPageId(String pageName) {
    return Uuid().v4() + '#$pageName';
  }
}

