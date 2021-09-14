
import 'package:blade/messenger/NativeEvents/base/native_event.dart';
import 'package:blade/messenger/page_info.dart';

class PopUntilNativePageEvent extends NativeEvent {
  PopUntilNativePageEvent(PageInfo pageInfo): super('popUntilNativePage', pageInfo);
}