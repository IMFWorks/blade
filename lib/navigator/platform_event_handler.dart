import 'package:blade/messenger/event_dispatcher.dart';
import 'package:blade/messenger/page_info.dart';
import 'package:blade/navigator/base_navigator.dart';
import 'package:blade/navigator/pop_mixin.dart';
import 'package:blade/navigator/push_mixin.dart';

mixin PlatformEventHandler on BaseNavigator, PushMixin, PopMixin implements PageEventListener {

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
    remove(pageInfo);
  }

  void onPageAppeared(PageInfo pageInfo) {
    print('onPageAppeared');
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

