import 'package:blade/blade_navigator.dart';
import 'package:blade/container/blade_container.dart';
import 'package:blade/navigator/platform_event_handler.dart';
import 'package:blade/messenger/event_dispatcher.dart';
import 'package:blade/navigator/pop_mixin.dart';
import 'package:blade/navigator/push_mixin.dart';

import '../container/blade_container.dart';
import '../container/blade_page.dart';
import '../container/container_manager.dart';
import '../messenger/page_info.dart';
import 'base_navigator.dart';

class BladeNavigatorImpl extends BaseNavigator with BladeNavigator,
    PushMixin,
    PopMixin,
    PlatformEventHandler {
  late EventDispatcher eventDispatcher;
  late ContainerManager containerManager;

  @override
  BladeContainer get topContainer {
    return containerManager.topContainer;
  }

  BladeNavigatorImpl(BladeRouteFactory routeFactory, String initialRoute) {
    this.containerManager = ContainerManager(routeFactory);
    final name = initialRoute;
    final pageInfo = PageInfo(name: name, id: createPageId(name));
    final initialContainer = containerManager.createContainer(pageInfo);
    containerManager.addContainer(initialContainer);
    eventDispatcher = EventDispatcher();

    init();
  }
}