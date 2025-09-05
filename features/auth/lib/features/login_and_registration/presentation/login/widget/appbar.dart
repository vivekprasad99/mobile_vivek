import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, Function()? onTap) {
  return AppBar(
    leading: IconButton(
      icon:  Icon(Icons.arrow_back, color:Theme.of(context).iconTheme.color ),
      onPressed: onTap
    ),
    elevation: 0.0, //No shadow
  );
}
