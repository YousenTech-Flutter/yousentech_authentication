import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';

class OdooProjectOwnerConnectionHelper {
  static late OdooClient odooClient;
  static OdooSession? odooSession;
  static bool sessionClosed = false;

  static Future instantiateOdooConnection(
      {required String username, required String password}) async {    
    try {
      print("instantiateOdooConnection username $username password $password");
      print("odooSession befor username ${odooSession?.userName}");
      print("odooSession befor username ${odooSession?.userId}");
      odooClient = OdooClient(SharedPr.subscriptionDetailsObj!.url!);
      odooSession = await odooClient.authenticate(
          SharedPr.subscriptionDetailsObj!.db!, username, password);
      print("odooSession instantiateOdooConnection username ${odooSession?.userName}");
      print("odooSession instantiateOdooConnection username ${odooSession?.userId}");
      SharedPr.setSessionId(sessionId: "session_id=${odooSession!.id}");
    } on OdooException {
      return 'login_information_incorrect'.tr;
    } catch (e) {
      return 'exception'.tr;
    }
  }
}
