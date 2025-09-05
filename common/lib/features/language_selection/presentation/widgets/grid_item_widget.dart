import 'package:common/helper/constant_assets.dart';
import 'package:core/config/resources/app_decoration.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/language_response.dart';

class GridItemWidget extends StatelessWidget {
  const GridItemWidget(
    this.chooseLanguageGridItemObj,
    this.isSelected, {
    required this.onTap,
    super.key,
  });

  final Language chooseLanguageGridItemObj;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          children:
          [Container(
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      color: Theme.of(context).unselectedWidgetColor,
                      width: 1,
                      strokeAlign: strokeAlignCenter,
                    ),
                    color: Theme.of(context).cardColor,
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: Theme.of(context).cardColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 51,
                                  child: SvgPicture.asset(
                                      "${ConstantAssets.svgPath}${chooseLanguageGridItemObj.langCode!}_prefix_icon.svg",
                                      fit: BoxFit.contain,
                                      placeholderBuilder: (context) =>
                                          SvgPicture.asset(
                                            "${ConstantAssets.svgPath}en_prefix_icon.svg",
                                          )),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: chooseLanguageGridItemObj.langName! != "English" ? 6.0 : 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chooseLanguageGridItemObj.langName!,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      if(chooseLanguageGridItemObj.langName! != "English")
                                      Text(
                                        chooseLanguageGridItemObj.langTitle!,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                color:
                                                    Theme.of(context).hintColor,
                                                letterSpacing: 0.1,
                                                fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                ),

              ],
            ),
          ),
          if (isSelected)
            Positioned(
              right: 8,
              top: 8,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.space2, horizontal: AppDimens.space2),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: AppDimens.space18,
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                ),
                ),
            ],
          ),
        );
  }
}
