class PatientUser {
  String uid;
  String imageUrl;
  String emailid;
  String name;
  String nickName;
  String birthDate;
  int age;
  int gender;
  int height = 150;
  int weight = 50;
  bool isSmoker = false;
  bool isAlcoholic = false;
  bool isPhysicalActive = false;
  bool isPhysicallyChallenged = false;
  final medicalConditions = [];
  // text box to enter their past conditions
  int percentageofDisability = 0;
  final doctorsVisited = [];
  final details = [];

  PatientUser({
    required this.uid,
    required this.imageUrl,
    required this.emailid,
    required this.name,
    required this.nickName,
    required this.gender,
    required this.birthDate,
    required this.age,
    required this.height,
    required this.weight,
    required this.isSmoker,
    required this.isAlcoholic,
    required this.isPhysicalActive,
    required this.isPhysicallyChallenged,
  });

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
