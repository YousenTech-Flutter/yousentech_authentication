import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_widgets/utils/file_management.dart';

Future<String> handleException({dynamic exception, bool navigation = false, String? methodName}) async{
  if (exception is OdooSessionExpiredException) {
    return 'session_expired'.tr;
  } else if (exception is OdooException) {
    FileManagement.writeData('${'failed_connect_server'.tr} - $exception');
    return parseErrorMessage(exception.message) ?? 'failed_connect_server'.tr;
  } else if (exception is SocketException) {
    FileManagement.writeData("$methodName Socket Exception : $exception");
    var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)){
        return  "no_connection".tr;
      }
    if(exception.toString().contains("timeout period has expired") || exception.toString().contains("The remote computer refused the network connection")
    || exception.toString().contains("Failed to connect with server")  ){
      return 'failed_connect_server'.tr;
    }
    return "no_connection".tr;
  } else {
    if(exception.toString().contains("Failed to connect with server") ){
      return 'failed_connect_server'.tr;
    }
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
