import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';

import 'package:flutter/material.dart';

class LandingBannerShimmer extends StatelessWidget {
  const LandingBannerShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(labelLandingPageActiveOffers),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}
