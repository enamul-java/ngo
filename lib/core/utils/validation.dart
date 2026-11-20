


class Validation {
  void validateAge(int age) {
    if (age < 18) {
      throw Exception('User must be 18 or older');
    }else{
      print("Age is valid");
    }
  }

  bool validateAge2(int age) {
    if (age > 18) {
      return true;
    }else{
      return false;
    }
  }

  static String? emailValidation(String? email) {
    if (email == null || email
        .trim()
        .isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
        .hasMatch(email.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }
}