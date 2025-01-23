import 'dart:io';
import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_widgets/utils/file_management.dart';

String handleException(
    {dynamic exception, bool navigation = false, String? methodName}) {
  if (exception is OdooSessionExpiredException) {
    return 'session_expired'.tr;
  } else if (exception is OdooException) {
    FileManagement.writeData('${'failed_connect_server'.tr} - $exception');
    return parseErrorMessage(exception.message) ?? 'failed_connect_server'.tr;
  } else if (exception is SocketException) {
    FileManagement.writeData("$methodName Socket Exception : $exception");
    return "no_connection".tr;
  } else {
    FileManagement.writeData("$methodName Exception : $exception");
    return "exception".tr;
  }
}

String? parseErrorMessage(String errorResponse) {
  final regex = RegExp(r'odoo\.exceptions\.ValidationError:\s*(.*)');
  final match = regex.firstMatch(errorResponse);

  if (match != null) {
    final errorMessage = match.group(1)?.trim();
    return errorMessage;
  } else {
    return 'failed_connect_server'.tr;
  }
}
