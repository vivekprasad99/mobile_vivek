import 'package:flutter/material.dart';

import '../network/network_utils.dart';

class MFCMSImage extends StatelessWidget {
  final String url;
  const MFCMSImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    //if (AppConfig.shared.flavor == Flavor.prod) {
      return Image.network(
        url,
        headers: getCMSImageHeader(),
      );
    // } else {
    //   return Image.network(url);
    // }
  }
}
