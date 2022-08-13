import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  bool isDescription;

  TextFieldInput({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.isPass = false,
    required this.textInputType,
    this.isDescription = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return isDescription
        ? TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context)),
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8),
            ),
            keyboardType: textInputType,
            maxLines: null,
            obscureText: isPass,
          )
        : TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context)),
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8),
            ),
            keyboardType: textInputType,
            obscureText: isPass,
          );
  }
}
