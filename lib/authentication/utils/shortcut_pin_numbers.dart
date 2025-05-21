import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisplayShorts extends Intent {}

class Up extends Intent {}

class Down extends Intent {}

class Digit extends Intent {
  final dynamic actionKey;
  const Digit(this.actionKey);
}

Map<ShortcutActivator, Intent> shortcutPINNumbers = {
  LogicalKeySet(LogicalKeyboardKey.digit0): const Digit(0),
  LogicalKeySet(LogicalKeyboardKey.numpad0): const Digit(0),
  LogicalKeySet(LogicalKeyboardKey.digit1): const Digit(1),
  LogicalKeySet(LogicalKeyboardKey.numpad1): const Digit(1),
  LogicalKeySet(LogicalKeyboardKey.digit2): const Digit(2),
  LogicalKeySet(LogicalKeyboardKey.numpad2): const Digit(2),
  LogicalKeySet(LogicalKeyboardKey.digit3): const Digit(3),
  LogicalKeySet(LogicalKeyboardKey.numpad3): const Digit(3),
  LogicalKeySet(LogicalKeyboardKey.digit4): const Digit(4),
  LogicalKeySet(LogicalKeyboardKey.numpad4): const Digit(4),
  LogicalKeySet(LogicalKeyboardKey.digit5): const Digit(5),
  LogicalKeySet(LogicalKeyboardKey.numpad5): const Digit(5),
  LogicalKeySet(LogicalKeyboardKey.digit6): const Digit(6),
  LogicalKeySet(LogicalKeyboardKey.numpad6): const Digit(6),
  LogicalKeySet(LogicalKeyboardKey.digit7): const Digit(7),
  LogicalKeySet(LogicalKeyboardKey.numpad7): const Digit(7),
  LogicalKeySet(LogicalKeyboardKey.digit8): const Digit(8),
  LogicalKeySet(LogicalKeyboardKey.numpad8): const Digit(8),
  LogicalKeySet(LogicalKeyboardKey.digit9): const Digit(9),
  LogicalKeySet(LogicalKeyboardKey.numpad9): const Digit(9),
  LogicalKeySet(LogicalKeyboardKey.delete): const Digit("Delete"),
  LogicalKeySet(LogicalKeyboardKey.backspace): const Digit("Backspace"),
  LogicalKeySet(LogicalKeyboardKey.enter): const Digit("Enter"),
};
Map<ShortcutActivator, Intent> arrowKeys = {
  LogicalKeySet(LogicalKeyboardKey.arrowUp): Up(),
  LogicalKeySet(LogicalKeyboardKey.arrowDown): Down(),
};
