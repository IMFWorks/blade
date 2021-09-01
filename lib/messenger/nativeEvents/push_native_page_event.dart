import 'package:blade/messenger/NativeEvents/native_event.dart';
import 'package:blade/messenger/page_info.dart';

class PushNativePageEvent extends NativeEvent {
  PushNativePageEvent(PageInfo pageInfo): super('pushNativePage', pageInfo);
}