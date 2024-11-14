import 'package:flutter/material.dart';

const space = 10.0;
const padding = 20.0;

class MasterSpacer {
  static Width w = Width();
  static Height h = Height();
}

class Width {
  Widget fifty() {
    return const SizedBox(
      width: 50,
    );
  }

  Widget five() {
    return const SizedBox(
      width: 5,
    );
  }

  Widget ten() {
    return const SizedBox(
      width: 10,
    );
  }

  Widget space(double val) {
    return SizedBox(
      width: val,
    );
  }
}

class Height {
  Widget five() {
    return const SizedBox(
      height: 5,
    );
  }

  Widget ten() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget fifty() {
    return const SizedBox(
      height: 50,
    );
  }

  Widget space(double val) {
    return SizedBox(
      height: val,
    );
  }

  Widget max() {
    return Expanded(child: Container());
  }
}
