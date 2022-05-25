import 'package:flutter/material.dart';
import 'package:medrec/Pages/doctor_home_page.dart';
import 'package:medrec/Pages/login.dart';
import 'package:medrec/Pages/patient_home_page.dart';

class MyRoutes {
  static const String loginPage = "/loginPage";
  static const String doctorHomePage = "/doctorHome";
  static const String patientHomePage = "/patientHome";

  static final routes = <String, WidgetBuilder>{
    loginPage: (context) => const LoginPage(),
    doctorHomePage: (context) => const DoctorHomePage(),
    patientHomePage: (context) => const PatientHomePage(),
  };
}
