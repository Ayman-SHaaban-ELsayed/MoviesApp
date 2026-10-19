class AppValidators {
  AppValidators._();

  /// Email
  static String? validateEmail(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Please enter mobile or email";
    }

    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(text);

    if (!emailValid) {
      return "Please enter a valid email";
    }

    return null;
  }

  /// Password
  static String? validatePassword(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Please enter password";
    }

    if (text.length < 6) {
      return "Password must be at least 6 characters";
    }

    if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@#&*]).+$',
    ).hasMatch(text)) {
      return "Password must contain uppercase, lowercase, number and one of @ # & *";
    }

    return null;
  }

  /// Confirm Password
  static String? validateConfirmPassword(
      String? text,
      String password,
      ) {
    if (text == null || text.trim().isEmpty) {
      return "Please enter password";
    }
    if (text != password) {
      return "Passwords do not match";
    }
    return null;
  }

  /// Full Name
  static String? validateName(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Please enter your name";
    }

    final bool isValid = RegExp(
      r'^[a-zA-Z ]+$',
    ).hasMatch(text);

    if (!isValid) {
      return "Please enter a valid name";
    }

    return null;
  }

  /// Username
  static String? validateUsername(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Please enter username";
    }

    final bool isValid = RegExp(
      r'^[a-zA-Z0-9,.-]+$',
    ).hasMatch(text);

    if (!isValid) {
      return "Please enter a valid username";
    }

    return null;
  }

  /// Phone Number
  static String? validatePhoneNumber(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Please enter mobile number";
    }

    final bool isValid = RegExp(
      r'^[0-9]{11}$',
    ).hasMatch(text);

    if (!isValid) {
      return "Enter a valid mobile number";
    }

    return null;
  }

  /// Required Field
  static String? validateRequired(
      String? text, {
        String message = "This field is required",
      }) {
    if (text == null || text.trim().isEmpty) {
      return message;
    }
    return null;
  }
  static String? validateEventTitle(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Please Enter Event Title";
    }
    return null;
  }

  static String? validateEventDescription(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Please Enter Event Description";
    }
    return null;
  }
}
// final _formKey = GlobalKey<FormState>();
// void signIn() {
//   if (_formKey.currentState!.validate() == true) {
//     FocusScope.of(context).unfocus();
//     Navigator.of(context).pushReplacementNamed(AppRoutes.homeRoutesName);
//   }
// }