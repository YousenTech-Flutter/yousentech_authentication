import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:yousentech_authentication/authentication/utils/handle_exception_helper.dart';

class OdooProjectOwnerConnectionHelper {
  static late OdooClient odooClient;
  static OdooSession? odooSession;
  static bool sessionClosed = false;

  static Future instantiateOdooConnection(
      {required String username, required String password}) async {
    print("instantiateOdooConnection==========");
    try {
      odooClient = OdooClient(SharedPr.subscriptionDetailsObj!.url!);
      // odooSession = await odooClient.authenticate(
      //     SharedPr.subscriptionDetailsObj!.db!, username, password);
      odooSession = await odooClient.authenticate(
          SharedPr.subscriptionDetailsObj!.db!, "user1", 'e486a1fd1efbe3242d558fd4b37a8f2e1ced8fce');
      SharedPr.setSessionId(sessionId: "session_id=${odooSession!.id}");
    } on OdooException {
      return 'login_information_incorrect'.tr;
    } catch (e) {
      print("instantiateOdooConnection catch ==========$e");
      return 'exception'.tr;
    }
  }

  static Future destroySession() async {
    try {
      await odooClient.destroySession();
      odooSession = null;
    } catch (e) {
      odooSession = null;
      await handleException(
          exception: e, navigation: false, methodName: "destroySession");
    }
  }

  static Future checkSession() async {
    try {
      var result = await odooClient.checkSession();
      return result;
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "checkSession");
    }
  }
}
