import 'package:blade/container/blade_container.dart';

abstract class RawStack {
  void push(BladeContainer container);
  void remove(BladeContainer container);
}