import 'package:flutter/material.dart';
import 'package:idempiere_app/components/text_field_container.dart';
import 'package:idempiere_app/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
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
        obscureText: obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.grey),
          hintText: "Password",
          icon: const Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
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
              )),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
