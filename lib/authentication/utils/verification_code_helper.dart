import 'dart:math';

class VerificationCodeGeneratorHelper {
  static String generateCode({int length = 6}) {
    final Random random = Random();
    String code = '';
    for (int i = 0; i < length; i++) {
      code += random.nextInt(10).toString();
    }
    return code;
  }
}
