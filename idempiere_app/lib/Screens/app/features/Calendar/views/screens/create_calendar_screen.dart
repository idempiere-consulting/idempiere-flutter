import 'dart:convert';
//import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/Screens/app/features/Calendar/models/type_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

class CreateCalendarEvent extends StatefulWidget {
  const CreateCalendarEvent({Key? key}) : super(key: key);

  @override
  State<CreateCalendarEvent> createState() => _CreateCalendarEventState();
}

class _CreateCalendarEventState extends State<CreateCalendarEvent> {
  final json = {
    "types": [
      {"id": "CO", "name": "Completed"},
      {"id": "NY", "name": "Not Yet Started"},
      {"id": "WP", "name": "Work In Progress"},
    ]
  };

  List<Types>? getTypes() {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  String date = "";
  String dropdownValue = "";
  late List<Types> dropDownList;

  @override
  void initState() {
    super.initState();
    nameFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    dropDownList = getTypes()!;
    dropdownValue = "NY";
    String date = "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Crea To Do'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.offNamed('/Calendar');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                //createLead();
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionFieldController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                      border: OutlineInputBorder(),
                      labelText: 'Descrizione',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Data',
                    icon: const Icon(Icons.event),
                    onChanged: (val) => print(DateTime.parse(val)),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Inizio',
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) => print(val),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DateTimePicker(
                    type: DateTimePickerType.time,
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    timeLabelText: 'Ora Fine',
                    icon: const Icon(Icons.access_time),
                    onChanged: (val) => print(val),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                      print(dropdownValue);
                    },
                    items: dropDownList.map((list) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          list.name.toString(),
                        ),
                        value: list.id,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return const Text("desktop visual WIP");
          },
          desktopBuilder: (context, constraints) {
            return const Text("tablet visual WIP");
          },
        ),
      ),
    );
  }
}
