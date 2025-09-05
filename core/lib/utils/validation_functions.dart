/// Checks if string is phone number
bool isValidPhone(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    if (inputString.length > 11 || inputString.length < 10) return false;

    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

bool isText(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z]+$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

bool isValidName(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z. ]+$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}


bool isValidEmail(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;


 
}



/// Checks if string consist only numeric.
bool isNumeric(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^\d+$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

/// Password should have,
/// at least a upper case letter
///  at least a lower case letter
///  at least a digit
///  at least a special character [@#$%^&+=]
///  length of at least 4
/// no white space allowed
bool isValidPassword(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern =
        r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

bool isValidAadhaarNumber(String? value) {
  if (value?.length != 12 || !RegExp(r'^\d{12}$').hasMatch(value ?? "")) {
    return false;
  }
  return true;
}

bool isValidPanCardNo(String? value) {
  return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value!);
}

bool isValidAccountNumber(String? value) {
  return RegExp(r'^[A-Za-z0-9- ]+$').hasMatch(value!);
}

bool isValidLicenseNo(String? value) {
  return RegExp(
          r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$')
      .hasMatch(value!);
}

bool isValiPIN(String? value) {
  return RegExp(r'^(\d{4}|\d{6})$').hasMatch(value!);
}

bool isValidPhoneNumber(String? value) =>
    RegExp(r'^[6-9]\d{9}$').hasMatch(value ?? '');

bool validatePin(String pin) {
  // Check if the pin consists of exactly 4 digits
  if (pin.length != 4 || pin.contains(RegExp(r'\D'))) {
    return false;
  }

  // Check if the first 3 digits are not the same
  if (pin[0] == pin[1] && pin[1] == pin[2]) {
    return false;
  }

  // Check if the last 3 digits are not the same
  if (pin[1] == pin[2] && pin[2] == pin[3]) {
    return false;
  }

  // Check if the pin is not sequential
  int firstDigit = int.parse(pin[0]);
  int secondDigit = int.parse(pin[1]);
  int thirdDigit = int.parse(pin[2]);
  int fourthDigit = int.parse(pin[3]);

  if (secondDigit == firstDigit + 1 &&
      thirdDigit == secondDigit + 1 &&
      fourthDigit == thirdDigit + 1) {
    return false;
  }

  return true;
}

bool checkFirstThirdDigit(String pin) {
  // Check if the pin consists of exactly 4 digits
  if (pin.length != 4 || pin.contains(RegExp(r'\D'))) {
    return false;
  }

  // Check if the first 3 digits are not the same
  if (pin[0] == pin[1] && pin[1] == pin[2]) {
    return false;
  }

  return true;
}

bool checkMpinIntialState(String value) {
  if (value.isEmpty) {
    return true;
  } else {
    return false;
  }
}

bool checkLastThreeDigit(String pin) {
  // Check if the pin consists of exactly 4 digits
  if (pin.length != 4 || pin.contains(RegExp(r'\D'))) {
    return false;
  }

  // Check if the last 3 digits are not the same
  if (pin[1] == pin[2] && pin[2] == pin[3]) {
    return false;
  }

  return true;
}

bool checkSequential(String pin) {
  // Check if the pin consists of exactly 4 digits
  if (pin.length != 4 || pin.contains(RegExp(r'\D'))) {
    return false;
  }
  // Check if the pin is not sequential
  int firstDigit = int.parse(pin[0]);
  int secondDigit = int.parse(pin[1]);
  int thirdDigit = int.parse(pin[2]);
  int fourthDigit = int.parse(pin[3]);

  if (secondDigit == firstDigit + 1 &&
      thirdDigit == secondDigit + 1 &&
      fourthDigit == thirdDigit + 1) {
    return false;
  }

  return true;
}
