import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_details/config/routes/route.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/active_loans_tabs_screen/active_loans_tabs.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/active_loan_details_screen.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/open_bottom_sheet_set_reminder.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/soa_web_view.dart';
import 'package:product_details/presentation/screens/activeloanlistscreen/active_loan_list_screen.dart';
import 'package:product_details/presentation/screens/completedtabscreen/completed_tab_screen.dart';
import 'package:product_details/presentation/screens/paymentbreakupscreen/payment_detail_screen.dart';

final List<GoRoute> productDetailsRoutes = [
  GoRoute(
    path: Routes.productsLoanListPage.path,
    name: Routes.productsLoanListPage.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailsCubit>(
          create: (context) => di<ProductDetailsCubit>(),
        ),
        BlocProvider<AchCubit>(
          create: (context) => di<AchCubit>(),
        )
      ],
      child: const ProductDetailsActiveLoanScreen(),
    ),
  ),
  GoRoute(
    path: Routes.productsLoanDetailPage.path,
    name: Routes.productsLoanDetailPage.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailsCubit>(
          create: (context) => di<ProductDetailsCubit>(),
        ),
        BlocProvider<AchCubit>(
          create: (context) => di<AchCubit>(),
        )
      ],
      child: ActiveLoanDetailsTabContainerScreen(
          loanDetails: state.extra as ActiveLoanData),
    ),
  ),
  GoRoute(
    path: Routes.productsPaymentsDetailPage.path,
    name: Routes.productsPaymentsDetailPage.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<ProductDetailsCubit>(),
      child: PaymentDetailScreen(loanDetails: state.extra as ActiveLoanData),
    ),
  ),
  GoRoute(
    path: Routes.openBottomSheetPage.path,
    name: Routes.openBottomSheetPage.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<ProductDetailsCubit>(),
      child: OptionTenBottomsheet(
          basicDetailsResponse: state.extra as BasicDetailsResponse),
    ),
  ),
  //TODO: Removed this class when integration with backend is done  this is temporary
  GoRoute(
    path: Routes.generateSoaDocWebView.path,
    name: Routes.generateSoaDocWebView.name,
    builder: (context, state) {
      return SOAWebView(
        url: state.extra as String,
      );
    },
  ),
  GoRoute(
    path: Routes.activeProductsLoanListPage.path,
    name: Routes.activeProductsLoanListPage.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailsCubit>(
          create: (context) => di<ProductDetailsCubit>(),
        ),
        BlocProvider<AchCubit>(
          create: (context) => di<AchCubit>(),
        )
      ],
      child: ProductDetailLoanListScreen('active',
          data: ServicesNavigationRequest.fromJson(
              state.extra as Map<dynamic, dynamic>)),
    ),
  ),
  GoRoute(
    path: Routes.completedProductsLoanListPage.path,
    name: Routes.completedProductsLoanListPage.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailsCubit>(
          create: (context) => di<ProductDetailsCubit>(),
        ),
        BlocProvider<AchCubit>(
          create: (context) => di<AchCubit>(),
        )
      ],
      child: CompletedLoanListScreen('completed',
          data: ServicesNavigationRequest.fromJson(
              state.extra as Map<dynamic, dynamic>)),
    ),
  ),
];
