import 'package:core/config/string_resource/Strings.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class SecondFactorAuthHeader extends StatelessWidget {
  final String headerDesc;
  final String headerTitle;
  final TextStyle? titleTextStyle;
  final TextStyle? descTextStyle;
  const SecondFactorAuthHeader({
    super.key,
    this.headerDesc = "",
    this.headerTitle = "",
    this.titleTextStyle,
    this.descTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return _buildHeader();
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            headerTitle.isNotEmpty
                ? headerTitle
                : getString(msgEnterMoreDetails),
            style: titleTextStyle ?? theme.textTheme.headlineMedium,
          ),
        ),
        SizedBox(height: 11.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            headerDesc.isNotEmpty ? headerDesc : getString(msgWeNeedAFewMore),
            style: descTextStyle ?? theme.textTheme.bodyMedium,
          ),
        ),
        SizedBox(height: 12.v),
      ],
    );
  }
}
