import 'package:flutter/material.dart';
import "package:tasksphere/core/utils/dialogs/show_generic_dialog.dart";

Future<bool?> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Logout",
    content: "Do you want to logout this account?",
    optionsBuilder: () => {"Logout": true, "Cancel": false},
  );
}
