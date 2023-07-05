import '../services/path.dart';
import '../utils/constatnts.dart';

class User {
  String? id;
  String? name;
  String? address;
  String? phoneNumber;
  String? email;
  String? password;
  String? picture;
  String? gender;
  String? socketId;
  String? deviceToken;
  bool? connected;
  String? status;
  String? type;
  int? appointmentprice;
  String? firstname;
  String? lastname;
  String? speciality;
  String? description;
  String? reviews;
  String? verification;
  DateTime? dateofbirth;
  String? civilstate;
  int? nembredenfant;
  String? role;
  List<String>? education;
  List<String>? experience;
  List<String>? availability;
  List<String>? ratings;
  List<String>? appointment;
  List<String>? prescriptions;
  List<String>? emergencyContacts;
  List<String>? allergys;
  List<String>? diseases;
  List<String>? healthcareMetrics;
  List<String>? radiographies;
  List<String>? symptomChecks;
  List<String>? surgeries;
  List<String>? labresult;
  List<BuildingPicture>? buildingpictures;
  List<Map<String, Object?>>? patients;
  List<Map<String, Object?>>? healthcareproviders;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.appointment,
    this.address,
    this.phoneNumber,
    this.picture,
    this.gender,
    this.type,
    this.availability,
    this.buildingpictures,
    this.dateofbirth,
    this.description,
    this.education,
    this.emergencyContacts,
    this.experience,
    this.firstname,
    this.healthcareproviders,
    this.lastname,
    this.patients,
    this.prescriptions,
    this.allergys,
    this.diseases,
    this.healthcareMetrics,
    this.radiographies,
    this.ratings,
    this.speciality,
    this.status,
    this.surgeries,
    this.symptomChecks,
    this.reviews,
    this.verification,
    this.civilstate,
    this.nembredenfant,
    this.appointmentprice,
    this.connected,
    this.deviceToken,
    this.labresult,
    this.socketId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<String>? appointments = json['appointment'] != null
        ? List<String>.from(json['appointment'])
        : [];

    List<String>? allergys =
        json['allergys'] != null ? List<String>.from(json['allergys']) : [];

    List<String>? diseases =
        json['diseases'] != null ? List<String>.from(json['diseases']) : [];

    List<String>? healthcareMetrics = json['healthcareMetrics'] != null
        ? List<String>.from(json['healthcareMetrics'])
        : [];

    List<String>? radiographies = json['radiographies'] != null
        ? List<String>.from(json['radiographies'])
        : [];

    List<String>? surgeries =
        json['surgeries'] != null ? List<String>.from(json['surgeries']) : [];

    List<String>? symptomChecks = json['symptomChecks'] != null
        ? List<String>.from(json['symptomChecks'])
        : [];

    List<String>? prescriptions = json['prescriptions'] != null
        ? List<String>.from(json['prescriptions'])
        : [];

    List<String>? ratings =
        json['ratings'] != null ? List<String>.from(json['ratings']) : [];

    List<String>? emergencyContacts = json['emergencyContacts'] != null
        ? List<String>.from(json['emergencyContacts'])
        : [];

    List<Map<String, Object?>>? patients = json['patients'] != null
        ? (json['patients'] as List<dynamic>).map((item) {
            return {
              'patientId': item['patientId'],
              'status': item['status'] ?? 'Pending',
            };
          }).toList()
        : [];

    List<Map<String, Object?>>? healthcareproviders =
        json['healthcareproviders'] != null
            ? (json['healthcareproviders'] as List<dynamic>).map((item) {
                return {
                  'healthcareproviderId': item['patientId'],
                  'status': item['status'] ?? 'Pending',
                };
              }).toList()
            : [];

    String? userPic = json['picture'];
    userPic = userPic != null ? "$profilePicPath/$userPic" : kProfile;

    List<BuildingPicture>? buildingpictures = json['buildingpictures'] != null
        ? (json['buildingpictures'] as List<dynamic>)
            .map<BuildingPicture>((item) {
            String id = item['_id'];
            String url = "$buildingpicsPath/${item['url']}";
            return BuildingPicture(id: id, url: url);
          }).toList()
        : [];

    List<String>? education =
        json['education'] != null ? List<String>.from(json['education']) : [];

    List<String>? experience =
        json['experience'] != null ? List<String>.from(json['experience']) : [];

    List<String>? availability = json['availability'] != null
        ? List<String>.from(json['availability'])
        : [];

    return User(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      role: json['role'] as String?,
      appointment: appointments,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      picture: json['type'] != 'Doctor' &&
              json['role'] == 'HealthcareProvider' &&
              buildingpictures.isNotEmpty
          ? buildingpictures[0].url
          : json['picture'] != ""
              ? "$profilePicPath/${json['picture']}"
              : "",
      gender: json['gender'] as String? ?? "",
      type: json['type'] as String? ?? "",
      availability: availability,
      buildingpictures: buildingpictures,
      dateofbirth: json['dateofbirth'] != null
          ? DateTime.parse(json['dateofbirth'])
          : null,
      description: json['description'] as String?,
      reviews: json['reviews'] as String?,
      verification: json['verification'] as String?,
      civilstate: json['civilstate'] as String? ?? "",
      nembredenfant: json['nembredenfant'] as int? ?? 0,
      status: json['status'] as String?,
      firstname: json['firstname'] as String? ?? "",
      lastname: json['lastname'] as String? ?? "",
      speciality: json['speciality'] as String? ?? "",
      education: education,
      experience: experience,
      ratings: ratings,
      appointmentprice: json['appointmentprice'] as int?,
      connected: json['connected'] as bool?,
      socketId: json['socketId'] as String?,
      deviceToken: json['deviceToken'] as String?,
      prescriptions: prescriptions,
      emergencyContacts: emergencyContacts,
      allergys: allergys,
      diseases: diseases,
      healthcareMetrics: healthcareMetrics,
      radiographies: radiographies,
      symptomChecks: symptomChecks,
      surgeries: surgeries,
      labresult: json['labresult'] != null
          ? List<String>.from(json['labresult'])
          : null,
      patients: patients,
      healthcareproviders: healthcareproviders,
    );
  }
}

class BuildingPicture {
  String id;
  String url;

  BuildingPicture({required this.id, required this.url});
}
