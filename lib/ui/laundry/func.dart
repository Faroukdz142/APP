import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

String getLanguage(
    {required String name, required BuildContext context}) {
if (name=="No special instructions"){
  return S.of(context).noInstructions;
}else {
  return name;
}
}
