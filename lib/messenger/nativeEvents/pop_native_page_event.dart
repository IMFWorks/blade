import 'package:blade/messenger/NativeEvents/native_event.dart';
import 'package:blade/messenger/page_info.dart';

class PopNativePageEvent extends NativeEvent {
  PopNativePageEvent(PageInfo pageInfo): super('popNativePage', pageInfo);
}


