import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

/// example widget showing how to use signature widget
class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Customer Signature'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                setState(() => _controller.undo());
              },
              icon: const Icon(Icons.undo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () async {
                var data = await _controller.toPngBytes();
                var image64 = base64.encode(data!);
                print(image64);
              },
              icon: const Icon(
                Icons.save,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          /* Container(
                height: 300,
                child: const Center(
                  child: Text('Big container to test scrolling issues'),
                ),
              ), */
          //SIGNATURE CANVAS
          Signature(
            controller: _controller,
            height: size.height * 0.92,
            width: double.infinity,
            backgroundColor: Colors.white,
          ),
          //OK AND CLEAR BUTTONS
          /* Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //SHOW EXPORTED IMAGE IN NEW ROUTE
                IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      final Uint8List? data = await _controller.toPngBytes();
                      if (data != null) {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(),
                                body: Center(
                                  child: Container(
                                    color: Colors.grey[300],
                                    child: Image.memory(data),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.undo());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.redo());
                  },
                ),
                //CLEAR CANVAS
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                ),
              ],
            ),
          ), */
          /* Container(
                height: 300,
                child: const Center(
                  child: Text('Big container to test scrolling issues'),
                ),
              ), */
        ],
      ),
    );
  }
}
