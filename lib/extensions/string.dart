extension Validator on String {
  bool isValidEmail () {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }

  bool isValidPhone () {
    return this.isNotEmpty && (this.length > 10 && this.length < 15) && RegExp(r"^[0-9]+$").hasMatch(this);
  }
}