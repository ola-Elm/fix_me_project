import 'package:flutter/material.dart';

Widget defaultFormFiled({
  required TextEditingController controller,
  TextInputType? type,
  void Function(String)? onChang,
  void Function(String)? onSubmit,
  void Function()? onTap,
  String? Function(String?)? validate,
  required bool obscureText,
  IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
  required String hintText,
  IconData? icon,
  Color? iconColor,
}) =>
    TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: controller,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChang,
      validator: validate,
      onTap: onTap,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        //////////////

        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),

        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        //border: InputBorder.none,
        border: const OutlineInputBorder(),
      ),
    );
