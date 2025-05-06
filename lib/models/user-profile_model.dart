class UserProfile {
  String? firstName;
  DateTime? birthday;
  String? gender;
  bool showGender = false;
  List<String> interests = [];
  List<String> photos = [];

  // Default unnamed constructor
  UserProfile();

  // Factory constructor to create an empty profile
  factory UserProfile.empty() {
    return UserProfile();
  }

  // Method to check if the profile is complete
  bool isComplete() {
    return firstName != null &&
        birthday != null &&
        gender != null &&
        interests.isNotEmpty &&
        photos.length >= 2;
  }

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'showGender': showGender,
      'interests': interests,
      'photos': photos,
    };
  }
}