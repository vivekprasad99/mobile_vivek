import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/network/endpoints.dart';

enum _CCPs {
  fino(
    displayName: 'Fino Payments Bank (Fino)',
    url: ApiEndpoints.fino,
  ),
  csc(
    displayName:
        'Common Services Center e-Governance Services India Limited (CSC)  ',
    url: ApiEndpoints.csc,
  ),
  ippb(
    displayName: 'India Post Payments Bank (Post office)',
    url: ApiEndpoints.ippb,
  ),
  ;

  final String displayName;
  final String url;
  const _CCPs({
    required this.displayName,
    required this.url,
  });
}

class CashCollectionPointsTabView extends StatelessWidget {
  const CashCollectionPointsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(
            'You can pay at any of the following centres ',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            itemCount: _CCPs.values.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  height: 1,
                  color: AppColors.primaryLight6,
                ),
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final ccp = _CCPs.values[index];
              return GestureDetector(
                onTap: () {
                  final url = Uri.parse(ccp.url);
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
                child: Text(
                  ccp.displayName,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.secondaryLight,
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
