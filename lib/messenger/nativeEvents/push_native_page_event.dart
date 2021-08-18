import 'package:blade/messenger/NativeEvents/native_event.dart';
import 'package:blade/messenger/page_info.dart';

class PushNativePageEvent extends NativeEvent {
  final PageInfo pageInfo;

  PushNativePageEvent(this.pageInfo): super('pushNativePage', pageInfo);
}


