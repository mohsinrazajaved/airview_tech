class AppUser {
  String? uid;
  String? email;
  String? photoUrl;
  String? displayName;
  String? phone;
  String? country;
  String? city;

  AppUser({
    this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.phone,
    this.country,
    this.city,
  });

  Map<String, dynamic> toMap(AppUser user) {
    Map<String, dynamic> data = {};
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['photoUrl'] = user.photoUrl;
    data['displayName'] = user.displayName;
    data['phone'] = user.phone;
    data['country'] = user.country;
    data['city'] = user.city;
    return data;
  }

  AppUser.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    email = mapData['email'];
    photoUrl = mapData['photoUrl'];
    displayName = mapData['displayName'];
    phone = mapData['phone'];
    country = mapData['country'];
    city = mapData['city'];
  }

  static bool isPasswordValid(String text) {
    return text.replaceAll(RegExp(r"\s+"), "").isNotEmpty;
  }

  static bool isEmailValid(String text) {
    if (text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isUsernameValid(String text) {
    return text.replaceAll(RegExp(r"\s+"), "").isNotEmpty;
  }

  static bool isConfirmPassword(String oldText, String newText) {
    return oldText == newText;
  }

  static bool isNotEmpty(String text) {
    return text.isNotEmpty;
  }
}
