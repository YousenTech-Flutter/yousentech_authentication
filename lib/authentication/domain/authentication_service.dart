import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/authentication_data/support_ticket.dart';
import 'package:pos_shared_preferences/models/authentication_data/user.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/config/app_urls.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';
import '../utils/handle_exception_helper.dart';
import '../utils/odoo_connection_helper.dart';
import 'authentication_repository.dart';

class AuthenticationService implements AuthenticationRepository {
  static AuthenticationService? _authenticationServiceInstance;

  AuthenticationService._();

  static AuthenticationService getInstance() {
    _authenticationServiceInstance =
        _authenticationServiceInstance ?? AuthenticationService._();
    return _authenticationServiceInstance!;
  }
  List userFields = [
        'id',
        'name',
        'login',
        'image_1920',
        'pin_code',
        'pin_code_lock',
        'account_lock',
        // 'pos_config_ids',
        // 'allowed_to_exceed_item_stock_quantity',
        'prevent_selling_with_negative_quantity',
        // 'maximum_increase_allowed_unit_price',
        // 'maximum_decrease_allowed_unit_price',
        'edit_invoice_and_process_it_on_closing',
        'show_pos_app_settings',
        'allow_print_session_reports_for_other_users',
        // 'is_allowed_to_edit_price_limit',
        // 'is_allowed_to_view_price_limit',
        'show_final_report_for_all_session',
        'is_allowed_to_restore_local_db',
      ];
  // ========================================== [ CHANGE PASSWORD ] =============================================

  // ========================================== [ ACTIVATE PIN LOGIN ] =============================================
  @override
  Future activatePinLogin({required String pinCode}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.resUsers,
        'method': 'write',
        'args': [
          SharedPr.userObj!.id,
          {
            'pin_code': pinCode == '' ? null : pinCode,
          },
        ],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e, navigation: true, methodName: "activatePinLogin");
    }
  }

  // ============================ [ login with PIN ] ====================================

  @override
  Future<dynamic> authenticateUsingPIN({
    required String pinCode,
  }) async {
    try {
      var generalLocalDBinstance =
          GeneralLocalDB.getInstance<User>(fromJsonFun: User.fromJson);
      User userFromLocal = await generalLocalDBinstance!
          .show(val: SharedPr.chosenUserObj!.userName, whereArg: 'username');
      if (userFromLocal.password == null) {
        return "sign_in_using_username_at_least_one_time".tr;
      }
      OdooProjectOwnerConnectionHelper.odooSession = null;
      await OdooProjectOwnerConnectionHelper.instantiateOdooConnection(
          username: SharedPr.chosenUserObj!.userName!,
          password: userFromLocal.password!);
      if (SharedPr.currentPosObject!.isDiscountActivated ?? false) {
        userFields.addAll(
            ['discount_value', 'discount_control', 'priority_user_discount']);
      }

      List result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.resUsers,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['pin_code', '=', pinCode],
            ['login', '=', SharedPr.chosenUserObj!.userName],
          ],
          'fields': userFields,
        },
      });

      return result.isEmpty ? null : User.fromJson(result.first);
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "authenticateUsingPIN");
    }
  }

  @override
  Future authenticateUsingUsernameAndPassword(
      {required String username, required String password}) async {
    try {
      OdooProjectOwnerConnectionHelper.odooSession = null;
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        var odooConnectionResult =
            await OdooProjectOwnerConnectionHelper.instantiateOdooConnection(
                username: username, password: password);
        if (odooConnectionResult is String) {
          return odooConnectionResult;
        }
        if (SharedPr.currentPosObject?.isDiscountActivated ?? false) {
          userFields.addAll(
              ['discount_value', 'discount_control', 'priority_user_discount']);
        }
        if (OdooProjectOwnerConnectionHelper.odooSession == null) {
          return 'session_expired'.tr;
        }
        List result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
          'model': OdooModels.resUsers,
          'method': 'search_read',
          'args': [],
          'kwargs': {
            //'context': {'bin_size': true}, // for user image
            'domain': [
              ['id', '=', OdooProjectOwnerConnectionHelper.odooSession!.userId]
            ],
            'fields': userFields,
          },
        });
        return User.fromJson(result.first);
      } else {
        return 'no_connection'.tr;
      }
    }
    catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "authenticateUsingUsernameAndPassword");
    }
  }
  @override
  Future changePassword({required String password}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.resUsers,
        // 'method': 'change_password',
        'method': 'write',
        'args': [
          // SharedPr.userObj!.password, password

          SharedPr.userObj!.id,
          {"password": password},
        ],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e, navigation: true, methodName: "changePassword");
    }
  }

// ========================================== [ COUNT USERNAME FAILURE ATTEMPT ] =============================================

// ========================================== [ COUNT PIN FAILURE ATTEMPT ] =============================================
  @override
  Future countPINFailureAttempt({bool reset = false}) async {
    try {
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.resUsers,
        'method': 'write',
        'args': [
          SharedPr.chosenUserObj!.id,
          {
            'pin_code_lock': reset ? 0 : SharedPr.chosenUserObj!.pinCodeLock!,
          },
        ],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "countPINFailureAttempt");
    }
  }

// ========================================== [ ACTIVATE PIN LOGIN ] =============================================

// ========================================== [ COUNT USERNAME FAILURE ATTEMPT ] =============================================
  @override
  Future countUsernameFailureAttempt({bool reset = false}) async {
    try {
      var generalLocalDBinstance =
          GeneralLocalDB.getInstance<User>(fromJsonFun: User.fromJson);
      User? userFromLocal = await generalLocalDBinstance!
          .show(val: SharedPr.chosenUserObj!.userName, whereArg: 'username');
      if (OdooProjectOwnerConnectionHelper.odooSession == null) {
        if (userFromLocal != null) {
          await OdooProjectOwnerConnectionHelper.instantiateOdooConnection(
              username: userFromLocal.password == null
                  ? supportAccountUsername
                  : SharedPr.chosenUserObj!.userName!,
              password: userFromLocal.password == null
                  ? supportAccountPassword
                  : userFromLocal.password!);
        }
        // OdooProjectOwnerConnectionHelper.odooSession = null;
      }
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.resUsers,
        'method': 'write',
        'args': [
          SharedPr.chosenUserObj!.id,
          {
            'account_lock': reset ? 0 : SharedPr.chosenUserObj!.accountLock!,
            'pin_code_lock': reset ? 0 : SharedPr.chosenUserObj!.pinCodeLock!,
          },
        ],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "countUsernameFailureAttempt");
    }
  }

  // ============================ [ login with PIN ] ====================================

  @override
  Future forgetPassword(
      {required String userId, required String verificationNumber}) async {
    try {
      // check if there is session opened before he access to this part
      if (OdooProjectOwnerConnectionHelper.odooSession == null) {
        // in every project there is support account
        await OdooProjectOwnerConnectionHelper.instantiateOdooConnection(
            username: supportAccountUsername, password: supportAccountPassword);
      }

      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.posSessionTransit,
        'method': 'send_whatsapp',
        'args': [userId, verificationNumber],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e, navigation: true, methodName: "forgetPassword");
    }
  }

  Future sendTicketToEliminateAccountLock() async {
    try {
      // check if there is session opened before he access to this part
      if (OdooProjectOwnerConnectionHelper.odooSession == null) {
        // in every project there is support account
        await OdooProjectOwnerConnectionHelper.instantiateOdooConnection(
            username: supportAccountUsername, password: supportAccountPassword);
      }

      int result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.accountLockSupportTicket,
        'method': 'create',
        'args': [
          SupportTicket(
            title: "Account Unlock Request",
            userId: SharedPr.chosenUserObj!.id,
          ).toJson()
        ],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "sendTicketToEliminateAccountLock");
    }
  }

// ========================================== [ COUNT PIN FAILURE ATTEMPT ] =============================================

  Future<dynamic> getUserAccountLockTicket() async {
    try {
      // check if there is session opened before he access to this part
      if (OdooProjectOwnerConnectionHelper.odooSession == null) {
        // in every project there is support account
        await OdooProjectOwnerConnectionHelper.instantiateOdooConnection(
            username: supportAccountUsername, password: supportAccountPassword);
      }
      List result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.accountLockSupportTicket,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['user_id', '=', SharedPr.chosenUserObj!.id],
            ['status', '=', false],
          ],
          'fields': [],
          'order': 'id desc'
        },
      });
      return result.isEmpty ? [] : SupportTicket.fromJson(result.first);
    } catch (e) {
      if (e.toString().contains("Null check operator used on a null value")) {
        return e.toString();
      }
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "getUserAccountLockTicket");
    }
  }

  Future<dynamic> updateUserAccountLockStatusTicket({required int id}) async {
    try {
      // check if there is session opened before he access to this part
      if (OdooProjectOwnerConnectionHelper.odooSession == null) {
        // in every project there is support account
        await OdooProjectOwnerConnectionHelper.instantiateOdooConnection(
            username: supportAccountUsername, password: supportAccountPassword);
      }
      bool result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.accountLockSupportTicket,
        'method': 'write',
        'args': [
          id,
          {
            'status': true,
          },
        ],
        'kwargs': {},
      });

      return result;
    } catch (e) {
      return await handleException(
          exception: e,
          navigation: false,
          methodName: "updateUserAccountLockStatusTicket");
    }
  }

// ========================================== [ DROP USER TABLE ] =============================================

  @override
  Future deleteData() async {
    var generalLocalDBInstance =
        GeneralLocalDB.getInstance<User>(fromJsonFun: User.fromJson);
    return await generalLocalDBInstance!.deleteData();
  }

  @override
  Future dropTable() async {
    var generalLocalDBInstance =
        GeneralLocalDB.getInstance<User>(fromJsonFun: User.fromJson);
    return await generalLocalDBInstance!.dropTable();
  }

// ========================================== [ DROP USER TABLE ] =============================================

  Future getUserInformation() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        if (SharedPr.currentPosObject?.isDiscountActivated ?? false) {
          userFields.addAll(
              ['discount_value', 'discount_control', 'priority_user_discount']);
        }
        if (OdooProjectOwnerConnectionHelper.odooSession == null) {
          return 'session_expired'.tr;
        }
        List result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
          'model': OdooModels.resUsers,
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              ['id', '=', OdooProjectOwnerConnectionHelper.odooSession!.userId]
            ],
            'fields': userFields,
          },
        });
        return User.fromJson(result.first);
      } else {
        return 'no_connection'.tr;
      }
    } 
    catch (e) {
      return await handleException(exception: e,navigation: false,methodName: "getUserInformation");
    }
  }
}
