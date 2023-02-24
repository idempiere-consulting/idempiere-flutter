import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';

//models

//screens

import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

class CRMEditHTMLSalesOrder extends StatefulWidget {
  const CRMEditHTMLSalesOrder({Key? key}) : super(key: key);

  @override
  State<CRMEditHTMLSalesOrder> createState() => _CRMEditHTMLSalesOrderState();
}

class _CRMEditHTMLSalesOrderState extends State<CRMEditHTMLSalesOrder> {
  saveEditHTML() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_ContractArticle/${args["id"]}');

    var msg = jsonEncode(
        {"Help": await controller.editorController?.getSelectedText()});
    print(msg);

    //print(await controller.getText());
    /* var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    ); */
  }

  dynamic args = Get.arguments;
  // ignore: prefer_typing_uninitialized_variables

  String result = '';
  late HtmlEditorController controller = HtmlEditorController();

  String htmlText = "";

  @override
  void initState() {
    //bPName = TextEditingValue(text: Get.arguments['bPartner']);
    controller = HtmlEditorController();
    htmlText = args["html"];
    super.initState();
    //getAllDocType();
    //getAllBPartners();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Edit Article HTML'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                //editSalesOrder();
                saveEditHTML();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    initialText: args["html"],
                    hint: 'Loading...',
                    shouldEnsureVisible: true,
                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    onButtonPressed: (ButtonType type, bool? status,
                        Function? updateStatus) {
                      print(
                          "button '${describeEnum(type)}' pressed, the current selected status is $status");
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      print(
                          "dropdown '${describeEnum(type)}' changed to $changed");
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      print(url);
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      print(file.name); //filename
                      print(file.size); //size in bytes
                      print(file.extension); //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  otherOptions: OtherOptions(height: 550),
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    print('html before change is $currentHtml');
                  }, onChangeContent: (String? changed) {
                    print('content changed to $changed');
                  }, onChangeCodeview: (String? changed) {
                    print('code changed to $changed');
                  }, onChangeSelection: (EditorSettings settings) {
                    print('parent element is ${settings.parentElement}');
                    print('font name is ${settings.fontName}');
                  }, onDialogShown: () {
                    print('dialog shown');
                  }, onEnter: () {
                    print('enter/return pressed');
                  }, onFocus: () {
                    print('editor focused');
                  }, onBlur: () {
                    print('editor unfocused');
                  }, onBlurCodeview: () {
                    print('codeview either focused or unfocused');
                  }, onInit: () {
                    print('init');
                  },
                      //this is commented because it overrides the default Summernote handlers
                      /*onImageLinkInsert: (String? url) {
                    print(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                    print(file.base64);
                  },*/
                      onImageUploadError: (FileUpload? file, String? base64Str,
                          UploadError error) {
                    print(describeEnum(error));
                    print(base64Str ?? '');
                    if (file != null) {
                      print(file.name);
                      print(file.size);
                      print(file.type);
                    }
                  }, onKeyDown: (int? keyCode) {
                    print('$keyCode key downed');
                    print(
                        'current character count: ${controller.characterCount}');
                  }, onKeyUp: (int? keyCode) {
                    print('$keyCode key released');
                  }, onMouseDown: () {
                    print('mouse downed');
                  }, onMouseUp: () {
                    print('mouse released');
                  }, onNavigationRequestMobile: (String url) {
                    print(url);
                    return NavigationActionPolicy.ALLOW;
                  }, onPaste: () {
                    print('pasted into editor');
                  }, onScroll: () {
                    print('editor scrolled');
                  }),
                  plugins: [
                    SummernoteAtMention(
                        getSuggestionsMobile: (String value) {
                          var mentions = <String>['test1', 'test2', 'test3'];
                          return mentions
                              .where((element) => element.contains(value))
                              .toList();
                        },
                        mentionsWeb: ['test1', 'test2', 'test3'],
                        onSelect: (String value) {
                          print(value);
                        }),
                  ],
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [],
            );
          },
        ),
      ),
    );
  }
}
