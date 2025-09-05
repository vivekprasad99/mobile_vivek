import 'package:core/config/resources/app_colors.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';

class AddressTile extends StatelessWidget {
  final String title;
  final PermanentAddr address;
  const AddressTile({super.key, required this.address, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is SelectAddressState,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.h),
            border: Border.all(
                color: (state is SelectAddressState && state.address == address)
                    ? AppColors.borderLight
                    : AppColors.primaryLight6),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 12.0.v, right: 12.0.v),
            onTap: () {
              context.read<ProfileCubit>().setDeliveryAddress(address, title);
            },
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "${address.fullAddress}, ${address.city}, ${address.state}, ${address.postalCode}",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            trailing: (state is SelectAddressState && state.address == address)
                ? Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).primaryColor,
                        size: 16.h,
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
}
