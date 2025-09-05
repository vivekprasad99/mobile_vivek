import 'package:common/features/search/data/model/search_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/data/models/category_filter.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/widget/active_loan_items.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/routes/utils.dart';

// ignore_for_file: must_be_immutable
class ProductDetailLoanListScreen extends StatefulWidget {
  ProductDetailLoanListScreen(this.tabType, {super.key, this.data});

  String tabType;
  ServicesNavigationRequest? data;

  @override
  ProductDetailLoanListScreenState createState() =>
      ProductDetailLoanListScreenState();
}

class ProductDetailLoanListScreenState
    extends State<ProductDetailLoanListScreen>
    with AutomaticKeepAliveClientMixin<ProductDetailLoanListScreen> {
  bool _isAppBarEnabled = false;

  @override
  void initState() {
    if (widget.tabType == 'active' && isCustomer()) {
      BlocProvider.of<ProductDetailsCubit>(context)
          .getActiveLoansList(ActiveLoanListRequest(ucic: getUCIC()));
    }

    if (widget.data?.fromRoute != null) {
      _isAppBarEnabled = getPreviousRoute(context) == widget.data?.fromRoute;
    }

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: _isAppBarEnabled || (widget.data?.isFromSearch ?? false)
            ? customAppbar(
                context: context,
                title: getString(lblLoanDetailProductDetail),
                onPressed: () {
                  context.pop();
                },
              )
            : null,
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          buildWhen: (context, state) {
            return state is GetActiveLoansListSuccessState;
          },
          builder: (context, state) {
            if (state is LoadingState && state.isloading) {
              return  Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).highlightColor,
                  ),
                ),
              );
            }

            if (state is GetActiveLoansListSuccessState) {
              return SizedBox(
                width: SizeUtils.width,
                child: MFGradientBackground(
                  horizontalPadding: 0,
                  verticalPadding: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildActiveLoanListScreen(state.response.loanList!),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(child: Text(getString(lblErrorGenericProductDetail)));
          },
        ),
      ),
    );
  }

  void filterItems(String query) {
    List<ActiveLoanData> filteredList = loanLists
        .where((item) =>
            item.productCategory!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredList.clear();
      filteredList.addAll(filteredList);
    });
  }

  List<ActiveLoanData> get activeLoans => loanLists
      .where((loan) => loan.loanStatus?.toLowerCase() == 'active')
      .toList();

  List<ActiveLoanData> loanLists = [];

  buildActiveLoanListScreen(List<ActiveLoanData> loanList) {
    List<FilterProductCategory> productCategory = [];
    loanLists.clear();

    for (var element in loanList) {
      if (element.loanNumber!.isNotEmpty) {
        loanLists.add(element);
      }
    }
    productCategory.add(FilterProductCategory("All Product"));
    for (var element in loanList) {
      if (element.loanNumber!.isNotEmpty) {
        productCategory.add(FilterProductCategory(element.productCategory!));
      }
    }

    if (activeLoans.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 17.v),
          ActiveLoansItem(
               activeLoans,
              widget.tabType),
          SizedBox(height: 10.v),
        ],
      );
    } else {
      return _buildEmptyScreen(context);
    }
  }

  _buildEmptyScreen(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 250.v),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageView(
                imagePath: ImageConstant.vector,
                height: 50.adaptSize,
                width: 50.adaptSize,
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.backgroundDarkGradient6)),
            SizedBox(
              width: 15.v,
            ),
            Text(
                widget.tabType == "active"
                    ? "You have no active products"
                    : "You have no completed products",
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
