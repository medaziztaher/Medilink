import '../settings/path.dart';
import '../utils/constatnts.dart';
import 'buildingpic.dart';

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
  String? dateofbirth;
  String? civilstate;
  String? nembredenfant;
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

  User(
      {this.id,
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
      this.socketId});

factory User.fromJson(Map<String, dynamic> json) {
  List<String>? appointments;
  if (json['appointment'] != null) {
    appointments = List<String>.from(json['appointment']);
  }

  List<String>? allergys;
  if (json['allergys'] != null) {
    allergys = List<String>.from(json['allergys']);
  }

  List<String>? analyses;
  if (json['analyses'] != null) {
    analyses = List<String>.from(json['analyses']);
  }

  List<String>? diseases;
  if (json['diseases'] != null) {
    diseases = List<String>.from(json['diseases']);
  }

  List<String>? healthcareMetrics;
  if (json['healthcareMetrics'] != null) {
    healthcareMetrics = List<String>.from(json['healthcareMetrics']);
  }

  List<String>? radiographies;
  if (json['radiographies'] != null) {
    radiographies = List<String>.from(json['radiographies']);
  }

  List<String>? surgeries;
  if (json['surgeries'] != null) {
    surgeries = List<String>.from(json['surgeries']);
  }

  List<String>? healthjournals;
  if (json['healthjournals'] != null) {
    healthjournals = List<String>.from(json['healthjournals']);
  }

  List<String>? symptomChecks;
  if (json['symptomChecks'] != null) {
    symptomChecks = List<String>.from(json['symptomChecks']);
  }

  List<String>? prescriptions;
  if (json['prescriptions'] != null) {
    prescriptions = List<String>.from(json['prescriptions']);
  }

  List<String>? ratings;
  if (json['ratings'] != null) {
    ratings = List<String>.from(json['ratings']);
  }

  List<String>? medicalRecords;
  if (json['medicalRecords'] != null) {
    medicalRecords = List<String>.from(json['medicalRecords']);
  }

  List<String>? emergencyContacts;
  if (json['emergencyContacts'] != null) {
    emergencyContacts = List<String>.from(json['emergencyContacts']);
  }

  List<Map<String, Object?>>? patients;
  if (json['patients'] != null) {
    patients = [];
    for (var patient in json['patients']) {
      patients.add({
        'patientId': patient['patientId'],
        'status': patient['status'] ?? 'Pending',
      });
    }
  }

  List<Map<String, Object?>>? healthcareproviders;
  if (json['healthcareproviders'] != null) {
    healthcareproviders = [];
    for (var provider in json['healthcareproviders']) {
      healthcareproviders.add({
        'healthcareproviderId': provider['patientId'],
        'status': provider['status'] ?? 'Pending',
      });
    }
  }

  String? userPic = json['picture'];
  userPic = userPic != null ? "$profilePicPath/$userPic" : kProfile;

  List<BuildingPicture>? buildingpictures = json['buildingpictures'] != null
      ? (json['buildingpictures'] as List<dynamic>).map((item) {
          String id = item['id'];
          String url = "$buildingpicsPath/${item['url']}";
          return BuildingPicture(id: id, url: url);
        }).toList()
      : [];

  List<String>? education;
  if (json['education'] != null) {
    education = List<String>.from(json['education']);
  }

  List<String>? experience;
  if (json['experience'] != null) {
    experience = List<String>.from(json['experience']);
  }

  List<String>? availability;
  if (json['availability'] != null) {
    availability = List<String>.from(json['availability']);
  }

  return User(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    password: json['password'] as String?,
    role: json['role'] as String?,
    appointment: appointments,
    address: json['address'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    picture: userPic,
    gender: json['gender'] as String?,
    type: json['type'] as String?,
    availability: availability,
    buildingpictures: buildingpictures,
    dateofbirth: json['dateofbirth'] as String?,
    description: json['description'] as String?,
    reviews: json['reviews'] as String?,
    verification: json['verification'] as String?,
    civilstate: json['civilstate'] as String?,
    nembredenfant: json['nembredenfant'] as String?,
    status: json['status'] as String?,
    firstname: json['firstname'] as String?,
    lastname: json['lastname'] as String?,
    speciality: json['speciality'] as String?,
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
    labresult: json['labresult'] != null ? List<String>.from(json['labresult']) : null,
    patients: patients,
    healthcareproviders: healthcareproviders,
  );
}
}