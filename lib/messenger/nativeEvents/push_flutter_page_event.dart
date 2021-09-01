import 'package:blade/messenger/NativeEvents/native_event.dart';
import 'package:blade/messenger/page_info.dart';

class PushFlutterPageEvent extends NativeEvent {
  PushFlutterPageEvent(PageInfo pageInfo): super('pushFlutterPage', pageInfo);
}