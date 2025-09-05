import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, String loadingText){
  AlertDialog alert=AlertDialog(
    content: Row(
      children: [
         CircularProgressIndicator(color: Theme.of(context).primaryColor,),const SizedBox(width: 20,),
        Container(margin: const EdgeInsets.only(left: 7),child: Text(loadingText)),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}