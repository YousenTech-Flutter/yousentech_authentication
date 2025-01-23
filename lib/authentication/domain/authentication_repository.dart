
abstract class AuthenticationRepository {
  Future authenticateUsingPIN({
    required String pinCode,
  });

  Future authenticateUsingUsernameAndPassword({required String username, required String password});
  Future forgetPassword({required String userId, required String verificationNumber});

  Future changePassword({
    required String password
  });

  Future activatePinLogin({
    required String pinCode
  });

  Future countUsernameFailureAttempt();
  Future deleteData();
  Future dropTable();
  Future countPINFailureAttempt();
}
