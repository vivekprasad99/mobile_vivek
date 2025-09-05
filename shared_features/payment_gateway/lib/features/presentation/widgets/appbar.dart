


import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

AppBar buildCustomAppBar({required BuildContext context,required String title, List<Widget>? actions}){
  return AppBar(
      toolbarHeight: 64.h,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: Text(
        title,
        maxLines: 1,
        style: Theme.of(context).textTheme.titleLarge
      ),
      actions: actions,
    );
}