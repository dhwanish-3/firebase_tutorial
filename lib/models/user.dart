class AppUser {
  String uid;
  AppUser({this.uid = ''});
}

class UserData {
  final String uid;
  final String? name;
  final String? sugars;
  final int strength;

  UserData(
      {this.uid = '', this.sugars = '', this.strength = 100, this.name = ''});
}
