import 'package:flutter/widgets.dart';
import 'package:blade/container/blade_container.dart';

import 'blade_container.dart';
import 'blade_container_widget.dart';

class ContainerOverlayEntry extends OverlayEntry {
  ContainerOverlayEntry(BladeContainer container)
      : super(
      builder: (BuildContext ctx) => BladeContainerWidget(container: container),
      opaque: true,
      maintainState: true) {

    container.entryRemovedCallback = (){
      remove();
    };
  }
  bool _removed = false;

  @override
  void remove() {
    assert(!_removed);

    if (_removed) {
      return;
    }

    _removed = true;
    super.remove();
  }
}
