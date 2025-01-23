import 'package:flutter/material.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/utils/shortcut_pin_numbers.dart';
import 'package:yousentech_authentication/authentication/utils/submit_pin.dart';

Map<Type, Action<Intent>> pinShortcutAction(
    {required AuthenticationController authenticationController}) {
  return {
    Digit: CallbackAction<Digit>(onInvoke: (intent) {
      if (intent.actionKey == "Backspace") {
        return authenticationController.setPinKey(
            isClear: true, data: intent.actionKey);
      } else if (intent.actionKey == "Delete") {
        return authenticationController.setPinKey(isClear: true, data: "C");
      } else if (intent.actionKey == "Enter") {
        return subMitPIN(authenticationController: authenticationController);
      } else {
        return authenticationController.setPinKey(
            data: intent.actionKey.toString());
      }
    }),
  };
}
