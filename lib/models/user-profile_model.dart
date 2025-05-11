
class UserProfile {
  String? firstName;
  String? lastName;
  DateTime? birthday;
  String? gender;
  String? location;
  String? distance;
  bool showGender = false;
  List<String> interests = [];
  List<String> photos = [];
  int? age; // Added age field for ProfileCard compatibility

  // Default unnamed constructor
  UserProfile();

  // Factory constructor to create an empty profile
  factory UserProfile.empty() {
    return UserProfile();
  }

  // New factory constructor to map API data to UserProfile
  factory UserProfile.fromApiData(Map<String, dynamic> userData) {
    UserProfile profile = UserProfile();

    // Extract profile data if available
    Map<String, dynamic>? profileData = userData['profile'];

    if (profileData != null) {
      profile.firstName = profileData['firstName'] ?? userData['username']?.toString().split(' ').first;
      profile.lastName = profileData['lastName'] ?? userData['username']?.toString().split(' ').last;

      // Handle birthday
      if (profileData['birthday'] != null) {
        profile.birthday = DateTime.tryParse(profileData['birthday']);
      }

      // Calculate age from birthday if available
      if (profile.birthday != null) {
        final now = DateTime.now();
        profile.age = now.year - profile.birthday!.year -
            (now.month > profile.birthday!.month ||
                (now.month == profile.birthday!.month && now.day >= profile.birthday!.day) ? 0 : 1);
      } else {
        profile.age = profileData['age'] ?? 25; // Default age
      }

      profile.gender = profileData['gender'];
      profile.location = (profileData['city'] != null && profileData['country'] != null)
          ? "${profileData['city']}, ${profileData['country']}"
          : "Unknown location";

      // Distance placeholder - would need to be calculated based on user's location
      profile.distance = "Unknown distance";

      profile.showGender = profileData['gender'] != null;

      // Handle interests and hobbies
      if (profileData['interests'] is List) {
        profile.interests = List<String>.from(profileData['interests']);
      }

      if (profileData['hobbies'] is List) {
        // Add hobbies to interests
        profile.interests.addAll(List<String>.from(profileData['hobbies']));
      }

      // Handle photos
      if (profileData['photos'] is List) {
        profile.photos = List<String>.from(profileData['photos']);
      }
    } else {
      // Fallback to username if profile data is not available
      profile.firstName = userData['username']?.toString().split(' ').first ?? "Unknown";
      profile.lastName = userData['username']?.toString().split(' ').last ?? "User";
      profile.age = 25; // Default age
      profile.location = "Unknown location";
      profile.distance = "Unknown distance";
    }

    return profile;
  }

  // Method to check if the profile is complete
  bool isComplete() {
    return firstName != null &&
        lastName != null &&
        birthday != null &&
        gender != null &&
        location != null &&
        interests.isNotEmpty &&
        photos.length >= 2;
  }

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'location': location,
      'distance': distance,
      'showGender': showGender,
      'interests': interests,
    };
  }

  // Get display name for the profile card
  String get name {
    if (firstName != null && lastName != null) {
      return "$firstName $lastName";
    } else if (firstName != null) {
      return firstName!;
    } else {
      return "Unknown User";
    }
  }

  set photoUrl(String url) {
    if (photos.isEmpty) {
      photos.add(url);
    } else {
      photos[0] = url;
    }
  }


  // Get photo URL for the profile card
  String get photoUrl {
    if (photos.isNotEmpty) {
      return photos.first;
    } else {
      return "assets/images/backgroud.png"; // Default image
    }
  }
}