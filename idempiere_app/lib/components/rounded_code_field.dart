import 'package:flutter/material.dart';
import 'package:idempiere_app/components/text_field_container.dart';
import 'package:idempiere_app/constants.dart';

class RoundedCodeField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedCodeField({
    Key? key,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  State<RoundedCodeField> createState() => _RoundedCodeFieldState();
}

class _RoundedCodeFieldState extends State<RoundedCodeField> {
  bool obscureText = true;
  @override
  void initState() {
    super.initState();
    obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        //obscureText: obscureText,
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          hintText: "Code",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          /* suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText == true
                      ? obscureText = false
                      : obscureText = true;
                });
              },
              icon: const Icon(
                Icons.visibility,
                color: kPrimaryColor,
              )), */
          border: InputBorder.none,
        ),
      ),
    );
  }
}
