import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_widgets/config/app_shared_pr.dart';

class OdooProjectOwnerConnectionHelper {

  static late OdooClient odooClient;
  static OdooSession? odooSession;
  static bool sessionClosed = false;

  static Future instantiateOdooConnection({required String username, required String password}) async {
    // change 
    try {
      odooClient = OdooClient(SharedPr.subscriptionDetailsObj!.url!);
      odooSession = await odooClient.authenticate(
          SharedPr.subscriptionDetailsObj!.db!,
          username,
          password);
      SharedPr.setSessionId(sessionId: "session_id=${odooSession!.id}");
    } on OdooException {
      return 'login_information_incorrect'.tr;
    } catch (e) {
      return 'exception'.tr;
    }
  }

}