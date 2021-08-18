import 'package:blade/messenger/NativeEvents/native_event.dart';
import 'package:blade/messenger/page_info.dart';

class PopNativePageEvent extends NativeEvent {
  final PageInfo pageInfo;

  PopNativePageEvent(this.pageInfo): super('popNativePage', pageInfo);
}


