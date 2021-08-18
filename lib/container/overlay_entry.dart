import 'package:flutter/widgets.dart';
import 'package:blade/container/blade_container.dart';

final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();
List<ContainerOverlayEntry>? _lastEntries;

void insertEntry(BladeContainer container) {
  final OverlayState? overlayState = overlayKey.currentState;
  if (overlayState == null) {
    return;
  }

  final entry = ContainerOverlayEntry(container);
  overlayState.insert(entry);
}

void refreshOverlayEntries(List<BladeContainer> containers) {
  final OverlayState? overlayState = overlayKey.currentState;
  if (overlayState == null) {
    return;
  }

  final lastEntries = _lastEntries;
  if (lastEntries != null && lastEntries.isNotEmpty) {
    for (ContainerOverlayEntry entry in lastEntries) {
      entry.remove();
    }
  }

  final newEntries = containers
      .map<ContainerOverlayEntry>(
          (BladeContainer container) => ContainerOverlayEntry(container))
      .toList(growable: false);
  _lastEntries = newEntries;

  overlayState.insertAll(newEntries);
}

class ContainerOverlayEntry extends OverlayEntry {
  ContainerOverlayEntry(BladeContainer container)
      : super(
            builder: (BuildContext ctx) => container,
            opaque: true,
            maintainState: true) {

    container.attach(this);
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