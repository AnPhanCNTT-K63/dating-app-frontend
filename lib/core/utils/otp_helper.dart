String joinOtp(List<String> digits) {
  return digits.join();
}

bool isOtpComplete(List<String> digits) {
  return digits.every((d) => d.isNotEmpty);
}
