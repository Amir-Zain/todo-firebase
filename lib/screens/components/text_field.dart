import 'package:flutter/material.dart';
class TextFieldCustom extends StatelessWidget {
  final TextEditingController  textEditingController;
  final String  label;
  final bool isEnabled;
  const TextFieldCustom({Key? key, required this.textEditingController, required this.label, this.isEnabled = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   TextField(
      controller:textEditingController,
      enabled: isEnabled,
      decoration: InputDecoration(labelText: label,labelStyle: const TextStyle(color: Colors.white60),enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white60, width: 0.0),),
        disabledBorder:  const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white60, width: 0.0),),
      ),);
  }
}
