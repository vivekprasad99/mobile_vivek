import 'package:common/helper/constant_assets.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:faq/config/routes/route.dart' as faq_route;

class NoResultsFoundWidget extends StatelessWidget {
  const NoResultsFoundWidget({super.key, this.searchTitle});

  final String? searchTitle;

  @override
  Widget build(BuildContext context) {
    return noResultFoundWidget(context, searchTitle ?? "");
  }

  Padding noResultFoundWidget(BuildContext context, String searchTitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(ConstantAssets.svgNoSearch),
          SizedBox(
            width: 18.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.v,
              ),
              SizedBox(
                width: 230,
                child: Text(searchTitle,
                    style: Theme.of(context).textTheme.titleSmall,),
              ),
              SizedBox(
                height: 10.v,
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(faq_route.Routes.faq.name);
                },
                child: Text(
                  getString(msgSearchSeeAllFAQs),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).highlightColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
