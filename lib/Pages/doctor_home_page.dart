import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medrec/Utils/connector.dart';
import 'package:medrec/Utils/routes.dart';
import 'package:web3dart/web3dart.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  TextEditingController feeController = TextEditingController();
  TextEditingController patientAddress = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController vitals = TextEditingController();
  TextEditingController medicines = TextEditingController();
  TextEditingController advice = TextEditingController();
  bool isAuthorized = false;
  bool showLoading = false;

  void checkAuthorization() async {
    if (patientAddress.text.length < 40) {
      Fluttertoast.showToast(msg: "Wrong address");
      return;
    }
    setState(() {
      showLoading = true;
    });
    isAuthorized = await Connector.isAuthorized(
        Connector.address, EthereumAddress.fromHex(patientAddress.text));
    if (!isAuthorized) {
      Fluttertoast.showToast(
          msg: "You are not authorized to give prescription.");
    }
    setState(() {
      showLoading = false;
    });
  }

  void updateFee(String newAmount) async {
    if (newAmount.isEmpty) {
      Fluttertoast.showToast(msg: "Amount cannot be empty");
      return;
    }
    setState(() {
      showLoading = true;
    });
    feeController.text = await Connector.updateDoctorFee(
        Connector.address, Connector.key, newAmount);
    setState(() {
      showLoading = false;
    });
  }

  void getFee() async {
    feeController.text = await Connector.getFee(Connector.address);
    setState(() {});
  }

  void sendPrescription() async {
    setState(() {
      showLoading = true;
    });
    String timestamp = DateTime.now().toString();
    String prescription =
        "$timestamp#${Connector.address}#${notes.text}#${vitals.text}#${medicines.text}#${advice.text}";
    await Connector.setPresc(
        Connector.address,
        EthereumAddress.fromHex(patientAddress.text),
        Connector.key,
        prescription);
    setState(() {
      showLoading = false;
      isAuthorized = false;
    });
  }

  @override
  void initState() {
    getFee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(50),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.userDoctor,
                      color: Colors.white,
                      size: 40,
                    ),
                    VerticalDivider(
                      color: Colors.white,
                      // thickness: 5,
                    ),
                    Text(
                      'Doctor Panel',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          Connector.address.toString(),
                          style: TextStyle(
                              fontSize:
                                  (MediaQuery.of(context).size.width * 0.02),
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Connector.key = "";
                        Navigator.popAndPushNamed(context, MyRoutes.loginPage);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                                fontSize:
                                    (MediaQuery.of(context).size.width * 0.02),
                                // fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              showLoading == false
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 16, top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                width: 200,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.ethereum,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                    VerticalDivider(
                                      color: Colors.black,
                                      thickness: 1,
                                    ),
                                    Text(
                                      'Update Fee',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CupertinoFormSection(
                                children: [
                                  CupertinoFormRow(
                                    child: CupertinoTextFormFieldRow(
                                      controller: feeController,
                                      placeholder: "Change Fee",
                                      padding: const EdgeInsets.only(left: 0),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Fee cannot be empty.";
                                        }
                                        return null;
                                      },
                                      enableSuggestions: true,
                                      prefix: Text(
                                        'Fee (In Wei)  | ',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => updateFee(feeController.text),
                                child: Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Update',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: null,
                      ),
                    ),
              showLoading == false
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 16, top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                // width: 250,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.prescriptionBottle,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: VerticalDivider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                    ),
                                    Text(
                                      'Give Prescription',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CupertinoFormSection(
                                children: [
                                  CupertinoFormRow(
                                    child: CupertinoTextFormFieldRow(
                                      controller: patientAddress,
                                      placeholder: "Patient Address",
                                      padding: const EdgeInsets.only(left: 0),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Address cannot be empty.";
                                        }
                                        return null;
                                      },
                                      prefix: Text(
                                        'Address  | ',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => checkAuthorization(),
                                child: Container(
                                    width: 200,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'Check Authorization',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    )),
                              ),
                            ),
                            isAuthorized
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        CupertinoFormSection(
                                          children: [
                                            CupertinoFormRow(
                                              child: CupertinoTextFormFieldRow(
                                                controller: notes,
                                                // placeholder: "Notes",
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Notes cannot be empty.";
                                                  }
                                                  return null;
                                                },
                                                prefix: Text(
                                                  'Notes  | ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                                expands: true,
                                                maxLength: null,
                                                maxLines: null,
                                              ),
                                            ),
                                            CupertinoFormRow(
                                              child: CupertinoTextFormFieldRow(
                                                controller: vitals,
                                                // placeholder: "Vitals",
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Vitals cannot be empty.";
                                                  }
                                                  return null;
                                                },
                                                prefix: Text(
                                                  'Vitals  | ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                                expands: true,
                                                maxLength: null,
                                                maxLines: null,
                                              ),
                                            ),
                                            CupertinoFormRow(
                                              child: CupertinoTextFormFieldRow(
                                                controller: medicines,
                                                // placeholder: "Patient Address",
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Medicines cannot be empty.";
                                                  }
                                                  return null;
                                                },
                                                prefix: Text(
                                                  'Medicines  | ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                                expands: true,
                                                maxLength: null,
                                                maxLines: null,
                                              ),
                                            ),
                                            CupertinoFormRow(
                                              child: CupertinoTextFormFieldRow(
                                                controller: advice,
                                                // placeholder: "Advice Address",
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Advice cannot be empty.";
                                                  }
                                                  return null;
                                                },
                                                prefix: Text(
                                                  'Advice  | ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                                expands: true,
                                                maxLength: null,
                                                maxLines: null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16, bottom: 16),
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () => sendPrescription(),
                                              child: Container(
                                                  width: 100,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        blurRadius: 7,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      'Send',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CupertinoActivityIndicator(
                          radius: 20,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
