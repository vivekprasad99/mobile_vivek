import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';
import 'package:product/presentation/cubit/product_feature_state.dart';
import 'package:product/presentation/widgets/products_list.dart';
import 'package:product/presentation/widgets/product_offers_slider.dart';

class ProductFeaturesScreen extends StatefulWidget {
  const ProductFeaturesScreen({super.key});

  @override
  State<ProductFeaturesScreen> createState() => _ProductFeaturesScreenState();
}

class _ProductFeaturesScreenState extends State<ProductFeaturesScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductFeatureCubit>(context).productFeature(
        productFeatureRequest: ProductFeatureRequest(ucic: getUCIC()));
    return BlocBuilder<ProductFeatureCubit, ProductFeatureState>(
        buildWhen: (context, state) {
      return true;
    }, builder: (context, state) {
      List<ProductFeature> productFeaturte = [];
      List<ProductBanner> productBanners = [];
      if (state is ProductFeatureSuccessState) {
        productFeaturte = state.response.productFeature!;
        productBanners = state.response.productBanner!;
      }
      return SafeArea(
        child: Scaffold(
          body: MFGradientBackground(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductOffersSlider(productBanner: productBanners),
                  if (state is LoadingState && state.isloading)
                    Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).highlightColor,
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: productFeaturte.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductsList(productFeaturte[index], index);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
