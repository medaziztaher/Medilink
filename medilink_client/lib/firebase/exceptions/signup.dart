class SignupFailure {
  final String message;
  const SignupFailure([this.message = "An unknow error occured."]);
  factory SignupFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupFailure('Please enter Stronger Password');
      case 'invalid_email':
        return const SignupFailure('Email is not valid or badly formatted');
      case 'email-already-in-use':
        return const SignupFailure('An account already exists fo that email.');
      case 'operation-not-allowed':
        return const SignupFailure('Operation is not allowed.Please contact support.');
      case 'user-disabled':
        return const SignupFailure(
            'this user has been disabled .Please contact support for help.');
      default:
        return const SignupFailure();
    }
  }
}
