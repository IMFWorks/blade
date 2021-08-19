import 'package:blade/messenger/event_dispatcher.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import 'package:blade/navigator/pop_mixin.dart';
import 'package:blade/navigator/push_mixin.dart';

mixin PlatformEventHandler on BaseNavigator, PushMixin, popMixin implements PageEventListener {

  void init() {
    super.init();

    eventDispatcher.pageEventListener = this;
  }

  // PageEventListener
  void pushPage(PageInfo pageInfo) {
    push(pageInfo);
  }

  void popPage(PageInfo pageInfo) {
    pop(id: pageInfo.id);
  }

  void removePage(PageInfo pageInfo) {
    // _removeContainer(pageInfo.id, targetContainers: _pendingPopcontainers);
    // _removeContainer(pageInfo.id, targetContainers: _containers);
  }

  void onPageAppeared(PageInfo pageInfo) {
    // PageVisibilityBinding.instance
    //     .dispatchPageShowEvent(_getCurrentPageRoute());
  }

  void onPageDisappeared(PageInfo pageInfo) {
    if (topContainer.pageInfo.id != pageInfo.id) {
      return;
    }

    // PageVisibilityBinding.instance
    //     .dispatchPageHideEvent(_getCurrentPageRoute());

  }

  void onForeground() {
    // PageVisibilityBinding.instance
    //     .dispatchForegroundEvent(_getCurrentPageRoute());
  }

  void onBackground() {
    // PageVisibilityBinding.instance
    //     .dispatchBackgroundEvent(_getCurrentPageRoute());
  }
}

