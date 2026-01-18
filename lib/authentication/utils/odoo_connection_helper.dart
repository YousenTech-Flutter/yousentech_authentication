import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
      print("dd1");
      var dd = await loginWithApiKey(
        db: SharedPr.subscriptionDetailsObj!.db!,
        login: "user1",
        baseUrl: SharedPr.subscriptionDetailsObj!.url!,
        apiKey: 'e486a1fd1efbe3242d558fd4b37a8f2e1ced8fce'
      );
      print("dd2============$dd");
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

  static Future<int> loginWithApiKey({
    required String baseUrl,
    required String db,
    required String login,
    required String apiKey,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {
          "service": "common",
          "method": "authenticate",
          "args": [db, login, apiKey, {}]
        }
      }),
    );
    final data = jsonDecode(response.body);
    if (data['result'] is int) {
      return data['result']; // uid
    }
    throw Exception('Authentication failed');
  }
}
