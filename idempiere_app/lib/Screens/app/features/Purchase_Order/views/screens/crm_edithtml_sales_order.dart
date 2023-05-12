import 'dart:convert';

import 'package:flutter/foundation.dart';
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

    var msg = jsonEncode({"Help": await controller.getText()});
    //print(msg);

    //print(await controller.getText());
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar(
        "Done!".tr,
        "The record has been updated".tr,
        duration: const Duration(milliseconds: 800),
        isDismissible: true,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      Get.snackbar(
        "Error!".tr,
        "Record not updated".tr,
        duration: const Duration(milliseconds: 800),
        isDismissible: true,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
      if (kDebugMode) {
        print(response.body);
      }
    }
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
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Editor HTML'.tr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                //editSalesOrder();
                controller.undo();
              },
              icon: const Icon(
                Icons.undo,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                //editSalesOrder();
                controller.redo();
              },
              icon: const Icon(
                Icons.redo,
              ),
            ),
          ),
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
                    hint: '',
                    shouldEnsureVisible: true,
                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    onButtonPressed: (ButtonType type, bool? status,
                        Function? updateStatus) {
                      if (kDebugMode) {
                        print(
                            "button '${describeEnum(type)}' pressed, the current selected status is $status");
                      }
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      if (kDebugMode) {
                        print(
                            "dropdown '${describeEnum(type)}' changed to $changed");
                      }
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      if (kDebugMode) {
                        print(url);
                      }
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      if (kDebugMode) {
                        print(file.name);
                      } //filename
                      if (kDebugMode) {
                        print(file.size);
                      } //size in bytes
                      if (kDebugMode) {
                        print(file.extension);
                      } //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  otherOptions: const OtherOptions(height: 550),
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    if (kDebugMode) {
                      print('html before change is $currentHtml');
                    }
                  }, onChangeContent: (String? changed) {
                    if (kDebugMode) {
                      print('content changed to $changed');
                    }
                  }, onChangeCodeview: (String? changed) {
                    if (kDebugMode) {
                      print('code changed to $changed');
                    }
                  }, onChangeSelection: (EditorSettings settings) {
                    if (kDebugMode) {
                      print('parent element is ${settings.parentElement}');
                    }
                    if (kDebugMode) {
                      print('font name is ${settings.fontName}');
                    }
                  }, onDialogShown: () {
                    if (kDebugMode) {
                      print('dialog shown');
                    }
                  }, onEnter: () {
                    if (kDebugMode) {
                      print('enter/return pressed');
                    }
                  }, onFocus: () {
                    if (kDebugMode) {
                      print('editor focused');
                    }
                  }, onBlur: () {
                    if (kDebugMode) {
                      print('editor unfocused');
                    }
                  }, onBlurCodeview: () {
                    if (kDebugMode) {
                      print('codeview either focused or unfocused');
                    }
                  }, onInit: () {
                    if (kDebugMode) {
                      print('init');
                    }
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
                    if (kDebugMode) {
                      print(describeEnum(error));
                    }
                    if (kDebugMode) {
                      print(base64Str ?? '');
                    }
                    if (file != null) {
                      if (kDebugMode) {
                        print(file.name);
                      }
                      if (kDebugMode) {
                        print(file.size);
                      }
                      if (kDebugMode) {
                        print(file.type);
                      }
                    }
                  }, onKeyDown: (int? keyCode) {
                    if (kDebugMode) {
                      print('$keyCode key downed');
                    }
                    if (kDebugMode) {
                      print(
                          'current character count: ${controller.characterCount}');
                    }
                  }, onKeyUp: (int? keyCode) {
                    if (kDebugMode) {
                      print('$keyCode key released');
                    }
                  }, onMouseDown: () {
                    if (kDebugMode) {
                      print('mouse downed');
                    }
                  }, onMouseUp: () {
                    if (kDebugMode) {
                      print('mouse released');
                    }
                  }, onNavigationRequestMobile: (String url) {
                    if (kDebugMode) {
                      print(url);
                    }
                    return NavigationActionPolicy.ALLOW;
                  }, onPaste: () {
                    if (kDebugMode) {
                      print('pasted into editor');
                    }
                  }, onScroll: () {
                    if (kDebugMode) {
                      print('editor scrolled');
                    }
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
                          if (kDebugMode) {
                            print(value);
                          }
                        }),
                  ],
                ),
              ],
            );
          },
          tabletBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    initialText: args["html"],
                    hint: '',
                    shouldEnsureVisible: true,
                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    onButtonPressed: (ButtonType type, bool? status,
                        Function? updateStatus) {
                      if (kDebugMode) {
                        print(
                            "button '${describeEnum(type)}' pressed, the current selected status is $status");
                      }
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      if (kDebugMode) {
                        print(
                            "dropdown '${describeEnum(type)}' changed to $changed");
                      }
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      if (kDebugMode) {
                        print(url);
                      }
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      if (kDebugMode) {
                        print(file.name);
                      } //filename
                      if (kDebugMode) {
                        print(file.size);
                      } //size in bytes
                      if (kDebugMode) {
                        print(file.extension);
                      } //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  otherOptions: const OtherOptions(height: 550),
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    if (kDebugMode) {
                      print('html before change is $currentHtml');
                    }
                  }, onChangeContent: (String? changed) {
                    if (kDebugMode) {
                      print('content changed to $changed');
                    }
                  }, onChangeCodeview: (String? changed) {
                    if (kDebugMode) {
                      print('code changed to $changed');
                    }
                  }, onChangeSelection: (EditorSettings settings) {
                    if (kDebugMode) {
                      print('parent element is ${settings.parentElement}');
                    }
                    if (kDebugMode) {
                      print('font name is ${settings.fontName}');
                    }
                  }, onDialogShown: () {
                    if (kDebugMode) {
                      print('dialog shown');
                    }
                  }, onEnter: () {
                    if (kDebugMode) {
                      print('enter/return pressed');
                    }
                  }, onFocus: () {
                    if (kDebugMode) {
                      print('editor focused');
                    }
                  }, onBlur: () {
                    if (kDebugMode) {
                      print('editor unfocused');
                    }
                  }, onBlurCodeview: () {
                    if (kDebugMode) {
                      print('codeview either focused or unfocused');
                    }
                  }, onInit: () {
                    if (kDebugMode) {
                      print('init');
                    }
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
                    if (kDebugMode) {
                      print(describeEnum(error));
                    }
                    if (kDebugMode) {
                      print(base64Str ?? '');
                    }
                    if (file != null) {
                      if (kDebugMode) {
                        print(file.name);
                      }
                      if (kDebugMode) {
                        print(file.size);
                      }
                      if (kDebugMode) {
                        print(file.type);
                      }
                    }
                  }, onKeyDown: (int? keyCode) {
                    if (kDebugMode) {
                      print('$keyCode key downed');
                    }
                    if (kDebugMode) {
                      print(
                          'current character count: ${controller.characterCount}');
                    }
                  }, onKeyUp: (int? keyCode) {
                    if (kDebugMode) {
                      print('$keyCode key released');
                    }
                  }, onMouseDown: () {
                    if (kDebugMode) {
                      print('mouse downed');
                    }
                  }, onMouseUp: () {
                    if (kDebugMode) {
                      print('mouse released');
                    }
                  }, onNavigationRequestMobile: (String url) {
                    if (kDebugMode) {
                      print(url);
                    }
                    return NavigationActionPolicy.ALLOW;
                  }, onPaste: () {
                    if (kDebugMode) {
                      print('pasted into editor');
                    }
                  }, onScroll: () {
                    if (kDebugMode) {
                      print('editor scrolled');
                    }
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
                          if (kDebugMode) {
                            print(value);
                          }
                        }),
                  ],
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    initialText: args["html"],
                    hint: '',
                    shouldEnsureVisible: true,
                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    onButtonPressed: (ButtonType type, bool? status,
                        Function? updateStatus) {
                      if (kDebugMode) {
                        print(
                            "button '${describeEnum(type)}' pressed, the current selected status is $status");
                      }
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      if (kDebugMode) {
                        print(
                            "dropdown '${describeEnum(type)}' changed to $changed");
                      }
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      if (kDebugMode) {
                        print(url);
                      }
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      if (kDebugMode) {
                        print(file.name);
                      } //filename
                      if (kDebugMode) {
                        print(file.size);
                      } //size in bytes
                      if (kDebugMode) {
                        print(file.extension);
                      } //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  otherOptions: const OtherOptions(height: 550),
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    if (kDebugMode) {
                      print('html before change is $currentHtml');
                    }
                  }, onChangeContent: (String? changed) {
                    if (kDebugMode) {
                      print('content changed to $changed');
                    }
                  }, onChangeCodeview: (String? changed) {
                    if (kDebugMode) {
                      print('code changed to $changed');
                    }
                  }, onChangeSelection: (EditorSettings settings) {
                    if (kDebugMode) {
                      print('parent element is ${settings.parentElement}');
                    }
                    if (kDebugMode) {
                      print('font name is ${settings.fontName}');
                    }
                  }, onDialogShown: () {
                    if (kDebugMode) {
                      print('dialog shown');
                    }
                  }, onEnter: () {
                    if (kDebugMode) {
                      print('enter/return pressed');
                    }
                  }, onFocus: () {
                    if (kDebugMode) {
                      print('editor focused');
                    }
                  }, onBlur: () {
                    if (kDebugMode) {
                      print('editor unfocused');
                    }
                  }, onBlurCodeview: () {
                    if (kDebugMode) {
                      print('codeview either focused or unfocused');
                    }
                  }, onInit: () {
                    if (kDebugMode) {
                      print('init');
                    }
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
                    if (kDebugMode) {
                      print(describeEnum(error));
                    }
                    if (kDebugMode) {
                      print(base64Str ?? '');
                    }
                    if (file != null) {
                      if (kDebugMode) {
                        print(file.name);
                      }
                      if (kDebugMode) {
                        print(file.size);
                      }
                      if (kDebugMode) {
                        print(file.type);
                      }
                    }
                  }, onKeyDown: (int? keyCode) {
                    if (kDebugMode) {
                      print('$keyCode key downed');
                    }
                    if (kDebugMode) {
                      print(
                          'current character count: ${controller.characterCount}');
                    }
                  }, onKeyUp: (int? keyCode) {
                    if (kDebugMode) {
                      print('$keyCode key released');
                    }
                  }, onMouseDown: () {
                    if (kDebugMode) {
                      print('mouse downed');
                    }
                  }, onMouseUp: () {
                    if (kDebugMode) {
                      print('mouse released');
                    }
                  }, onNavigationRequestMobile: (String url) {
                    if (kDebugMode) {
                      print(url);
                    }
                    return NavigationActionPolicy.ALLOW;
                  }, onPaste: () {
                    if (kDebugMode) {
                      print('pasted into editor');
                    }
                  }, onScroll: () {
                    if (kDebugMode) {
                      print('editor scrolled');
                    }
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
                          if (kDebugMode) {
                            print(value);
                          }
                        }),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
