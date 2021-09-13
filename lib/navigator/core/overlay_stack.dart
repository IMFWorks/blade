import 'package:blade/container/blade_container.dart';
import 'package:blade/container/container_overlay_entry.dart';
import 'package:blade/navigator/core/raw_stack.dart';
import 'package:flutter/widgets.dart';

class OverlayStack implements RawStack {
  final GlobalKey<OverlayState> overlayKey;
  List<ContainerOverlayEntry>? _lastEntries;

  OverlayStack(this.overlayKey);

  void push(BladeContainer container) {
    final OverlayState? overlayState = overlayKey.currentState;
    if (overlayState == null) {
      return;
    }

    final entry = ContainerOverlayEntry(container);
    overlayState.insert(entry);
  }

  void remove(BladeContainer container) {
    container.entryRemoved();
  }

  List<OverlayEntry> initialEntries(List<BladeContainer> containers) {
    final List<OverlayEntry> entries = <OverlayEntry>[];
    final overlayState = overlayKey.currentState;
    if (overlayState == null) {
      for (BladeContainer container in containers) {
        final ContainerOverlayEntry entry = ContainerOverlayEntry(container);
        entries.add(entry);
      }
    }

    return entries;
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
}