import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/models/contact.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/campaign_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/city_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/coutry_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/leadstatus.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/region_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/models/sector_json.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_image.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/models/attachment_json.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';

class DeskDocAttachmentsViewAttachmentScreen extends StatefulWidget {
  const DeskDocAttachmentsViewAttachmentScreen({Key? key}) : super(key: key);

  @override
  State<DeskDocAttachmentsViewAttachmentScreen> createState() =>
      _DeskDocAttachmentsViewAttachmentScreenState();
}

class _DeskDocAttachmentsViewAttachmentScreenState
    extends State<DeskDocAttachmentsViewAttachmentScreen> {
  attachFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    if (result != null) {
      //File file = File(result.files.first.bytes!);
      sendAttachedFile(result);
      //print(image64);
      //print(imageName);
    }
  }

  sendAttachedFile(FilePickerResult? result) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final msg = jsonEncode({
      "name": result!.files.first.name,
      "data": base64.encode(result.files.first.bytes!)
    });

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/${args['tableName']}/${args['recordId']}/attachments');

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      getAttachments();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  deleteAttachedFile(int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/${args['tableName']}/${args['recordId']}/attachments/${attachments.attachments![index].name}');

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      getAttachments();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAttachments() async {
    setState(() {
      dataAvailable = false;
    });
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/${args['tableName']}/${args['recordId']}/attachments');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      attachments =
          AttachmentJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      setState(() {
        dataAvailable = true;
      });
    } else {
      print(response.body);
    }
  }

  var args = Get.arguments;

  @override
  void initState() {
    super.initState();
    dataAvailable = false;
    getAttachments();
  }

  AttachmentJSON attachments = AttachmentJSON(attachments: []);

  bool dataAvailable = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('View Attachments'.tr),
        ),
        actions: [
          IconButton(
              onPressed: () {
                attachFile();
              },
              icon: Icon(Symbols.attach_file_add))
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
                ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: attachments.attachments!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: ListTile(
                          onTap: () async {
                            final ip = GetStorage().read('ip');
                            String authorization =
                                'Bearer ${GetStorage().read('token')}';
                            final protocol = GetStorage().read('protocol');
                            var url = Uri.parse(
                                '$protocol://$ip/api/v1/models/${args['tableName']}/${args['recordId']}/attachments/${attachments.attachments![index].name!}');
                            var response = await http.get(
                              url,
                              headers: <String, String>{
                                'Content-Type': 'application/json',
                                'Authorization': authorization,
                              },
                            );
                            if (response.statusCode == 200) {
                              if (attachments
                                      .attachments![index].contentType! ==
                                  "application/pdf") {
                                final bytes = response.bodyBytes;

                                if (Platform.isAndroid) {
                                  await Printing.layoutPdf(
                                      onLayout: (PdfPageFormat format) async =>
                                          bytes);
                                } else {
                                  final dir =
                                      await getApplicationDocumentsDirectory();
                                  final file = File(
                                      '${dir.path}/${attachments.attachments![index].name!}');
                                  await file.writeAsBytes(bytes, flush: true);
                                  await launchUrl(
                                      Uri.parse(
                                          'file://${'${dir.path}/${attachments.attachments![index].name!}'}'),
                                      mode: LaunchMode
                                          .externalNonBrowserApplication);
                                }
                              }

                              if (attachments
                                      .attachments![index].contentType! ==
                                  "image/jpeg") {
                                var image64 = base64.encode(response.bodyBytes);
                                Get.to(const DeskDocAttachmentsImage(),
                                    arguments: {"base64": image64});
                              }
                            }
                          },
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: kSpacing),
                          title: Text(attachments.attachments![index].name!),
                          subtitle: Text(
                            attachments.attachments![index].contentType!,
                            style: TextStyle(
                              fontSize: 11,
                              color: kFontColorPallets[2],
                            ),
                          ),
                          leading: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Symbols.delete,
                                color: Colors.red,
                              )),
                          /* trailing: IconButton(
                              onPressed: () {}, icon: Icon(Symbols.image)), */
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    })
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
