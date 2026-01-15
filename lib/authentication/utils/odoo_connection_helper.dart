import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:yousentech_authentication/authentication/utils/handle_exception_helper.dart';

class OdooProjectOwnerConnectionHelper {

  static late OdooClient odooClient;
  static OdooSession? odooSession;
  static bool sessionClosed = false;

  static Future instantiateOdooConnection({required String username, required String password}) async {
    print("instantiateOdooConnection==========");
    try {
      odooClient = OdooClient(SharedPr.subscriptionDetailsObj!.url!);
      odooSession = await odooClient.authenticate(
          SharedPr.subscriptionDetailsObj!.db!,
          username,
          password);
      await SharedPr.setOdooClientObj(odooClient: odooClient);
      print("odooClient==========$odooClient");
      SharedPr.setSessionId(sessionId: "session_id=${odooSession!.id}");
    } on OdooException {
      return 'login_information_incorrect'.tr;
    } catch (e) {
      return 'exception'.tr;
    }
  }

  static Future destroySession() async {
    print("destroySession==========");
    try {
      if(SharedPr.odooClient != null){
        odooClient = SharedPr.odooClient!;
      }
      await odooClient.destroySession();
      odooSession = null;
      SharedPr.setOdooClientObj(odooClient: null);
    }
    catch (e) {
      odooSession = null;
      SharedPr.setOdooClientObj(odooClient: null);
      await handleException(exception: e, navigation: false, methodName: "destroySession");
    }
  }
  static Future checkSession() async {
    try {
      print("SharedPr.odooClient ${SharedPr.odooClient}");
      if(SharedPr.odooClient != null){
        odooClient = SharedPr.odooClient!;
      }
    var result = await odooClient.checkSession();
    return result;
    }
    catch (e) {
      print("checkSession catch=========$e");
      return await handleException(exception: e, navigation: false, methodName: "checkSession");
    }
  }

}