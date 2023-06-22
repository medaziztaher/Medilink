class TExceptions {
  final String message;
  const TExceptions([this.message = "An unknow error occured."]);
  factory TExceptions.code(String code) {
    switch (code) {
      case 'weak-password':
        return const TExceptions('Please enter Stronger Password');
      case 'invalid_email':
        return const TExceptions('Email is not valid or badly formatted');
      case 'email-already-in-use':
        return const TExceptions('An account already exists fo that email.');
      case 'operation-not-allowed':
        return const TExceptions('Operation is not allowed.Please contact support.');
      case 'user-disabled':
        return const TExceptions(
            'this user has been disabled .Please contact support for help.');
             case 'user-not-found':
        return const TExceptions(
            'Invalid details,please create an account');
             case 'wrong-password':
        return const TExceptions(
            '');
      default:
        return const TExceptions();
    }
  }
}
