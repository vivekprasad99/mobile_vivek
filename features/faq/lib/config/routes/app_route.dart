import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/screen/faq_search_screen.dart';
import 'package:faq/features/presentation/screen/how_to_category.dart';
import 'package:faq/features/presentation/screen/product_item_screen.dart';
import 'package:faq/features/presentation/screen/youtube_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:faq/config/routes/route.dart';
import 'package:core/services/di/injection_container.dart';
import '../../features/presentation/cubit/faq_cubit.dart';
import '../../features/presentation/screen/faq_screen.dart';

final List<GoRoute> faqRoutes = [
  GoRoute(
      path: Routes.faq.path,
      name: Routes.faq.name,
      builder: (_, __) => BlocProvider<FAQCubit>(
          create: (context) => di<FAQCubit>(),
          child: const FAQScreen())),
  GoRoute(
      path: Routes.howToCategory.path,
      name: Routes.howToCategory.name,
      builder: (context, state) => BlocProvider<FAQCubit>(
            create: (context) => di<FAQCubit>(),
            child: HowToCategoryScreen(videoTypes: state.extra as VideoTypes),
          )),
  GoRoute(
      path: Routes.youtubePlayerScreen.path,
      name: Routes.youtubePlayerScreen.name,
      builder: (context, state) => BlocProvider<FAQCubit>(
        create: (context) => di<FAQCubit>(),
        child: YoutubePlayerScreen(videoUrl: state.extra as String),
      )),
  GoRoute(
      path: Routes.productItemScreen.path,
      name: Routes.productItemScreen.name,
      builder: (context, state) => BlocProvider<FAQCubit>(
            create: (context) => di<FAQCubit>(),
            child: ProductItemScreen(state.extra as Map<String, dynamic>),
      )),
   GoRoute(
      path: Routes.faqSearchScreen.path,
      name: Routes.faqSearchScreen.name,
      builder: (context, state) => BlocProvider<FAQCubit>(
            create: (context) => di<FAQCubit>(),
            child:  FAQSearchScreen(
              key: UniqueKey(),
              data: state.extra as FAQsAgruments?,
            ),
      )),

];
