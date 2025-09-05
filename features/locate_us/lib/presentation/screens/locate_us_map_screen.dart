import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/locate_us_cubit.dart';
import '../utils/map_utils.dart';
import '../widgets/locate_us_branch_tab_view_widget.dart';
import '../widgets/locate_us_state_city_location_widget.dart';
import 'locate_us_error_screen.dart';

class LocateUsMapScreen extends StatefulWidget {
  const LocateUsMapScreen({super.key});

  @override
  State<LocateUsMapScreen> createState() => _LocateUsMapScreenState();
}

class _LocateUsMapScreenState extends State<LocateUsMapScreen>
    with TickerProviderStateMixin {
  //? Maps
  final double cameraZoom = 16;
  final LatLng defaultLocation = const LatLng(18.9389, 72.8256);
  late CameraPosition initialCameraPosition;
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  //? sheet
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapseSheet();

    if (currentSize > 0.95) {
      _opacityAnimationController.value = currentSize;
      _radiusAnimationController.value = currentSize;
      // _controller
    } else {
      _opacityAnimationController.value = 0.0;
      _radiusAnimationController.value = 0.0;
    }
  }

  void _collapseSheet() => _animateSheet(sheet.snapSizes!.first);

  void _expandSheet() => _animateSheet(1);

  void _halfCollapseSheet() => _animateSheet(0.5);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: _animationDuration,
      curve: Curves.easeInOut,
    );
  }

  //? opacity animation
  final double _initialOpacity = 1.0;
  final double _finalOpacity = 0.0;

  late final AnimationController _opacityAnimationController;
  late final Animation<double> _opacityAnimation;

  //? radius animation
  final double _initialRadius = 0.0;
  final double _finalRadius = 28;

  late final AnimationController _radiusAnimationController;
  late Animation<double> _radiusAnimation;

  //? init state
  @override
  void initState() {
    super.initState();
    context.read<LocateUsCubit>().getBranchesFromLatLong();
    initialCameraPosition = CameraPosition(
      target: defaultLocation,
      zoom: cameraZoom,
    );
    _controller.addListener(_onChanged);
    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _opacityAnimation = Tween<double>(
      begin: _initialOpacity,
      end: _finalOpacity,
    ).animate(_opacityAnimationController);

    _radiusAnimationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _radiusAnimation = Tween<double>(
      begin: _initialRadius,
      end: _finalRadius,
    ).animate(_radiusAnimationController);
  }

  //? dispose
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _opacityAnimationController.dispose();
    _radiusAnimationController.dispose();
  }

  //? utils
  final _animationDuration = const Duration(milliseconds: 100);
  void _handleBackButton() {
    if (_controller.size >= 0.9) {
      _animateSheet(sheet.snapSizes!.first);
      _controller.jumpTo(0);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocateUsCubit, LocateUsState>(
      builder: (context, state) {
        if (state is LoadingState && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FailureState) {
          return LocateUsErrorScreen(
            msg: getFailureMessage(state.failure),
          );
        } else if (state is GetBranchesSuccessState) {
          if (state.branches.code == AppConst.codeFailure) {
            return LocateUsErrorScreen(
              msg: getString(state.branches.responseCode ?? ""),
            );
          }
          final Set<Marker> markers = state.branches.branchList
                  ?.where((element) => (((element.lat ?? 0.0) != 0.0) ||
                      ((element.lon ?? 0.0) != 0.0)))
                  .map(
                    (b) => Marker(
                      markerId: MarkerId(b.name ?? ''),
                      position: LatLng(b.lat!, b.lon!),
                      infoWindow: InfoWindow(
                        title: b.name ?? '',
                        snippet: b.address,
                        onTap: () {
                          MapsUtils.launchCoordinates(b.lat!, b.lon!);
                        },
                      ),
                    ),
                  )
                  .toSet() ??
              {};
          return BackButtonListener(
            onBackButtonPressed: () async {
              _handleBackButton();
              return true;
            },
            child: Scaffold(
              appBar: customAppbar(
                context: context,
                title: getString(lblLoUsLocateUs),
                onPressed: _handleBackButton,
              ),
              body: Stack(
                children: [
                  //? Map - Behind
                  GoogleMap(
                    key: const Key("Google Map"),
                    mapType: MapType.normal,
                    initialCameraPosition: initialCameraPosition,
                    markers: markers,
                    onMapCreated: (GoogleMapController controller) {
                      if (markers.isNotEmpty) {
                        controller.moveCamera(
                            CameraUpdate.newLatLng(markers.first.position));
                      }
                      // _controller.complete(controller);
                    },
                  ),

                  //? bottom sheet
                  DraggableScrollableSheet(
                    key: _sheet,
                    initialChildSize: 0.5,
                    maxChildSize: 1,
                    minChildSize: 0.2,
                    expand: true,
                    snap: true,
                    snapSizes: const [0.2, 0.5, 0.75],
                    controller: _controller,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return AnimatedBuilder(
                        animation: _radiusAnimationController,
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  _finalRadius - _radiusAnimation.value),
                              topRight: Radius.circular(
                                  _finalRadius - _radiusAnimation.value),
                            ),
                            child: child,
                          );
                        },
                        child: ColoredBox(
                          color: Colors.white,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).colorScheme.background,
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                                stops: const [0.0086, 0.992, 0.3493],
                              ),
                            ),
                            child: CustomScrollView(
                              controller: scrollController,
                              slivers: [
                                SliverToBoxAdapter(
                                  child: AnimatedBuilder(
                                      animation: _radiusAnimationController,
                                      builder: (context, _) {
                                        return AnimatedSize(
                                          duration: _animationDuration,
                                          child: SizedBox(
                                            height: _radiusAnimationController
                                                    .value *
                                                30,
                                          ),
                                        );
                                      }),
                                ),
                                SliverToBoxAdapter(
                                  child: Center(
                                    child: AnimatedBuilder(
                                      animation: _opacityAnimation,
                                      builder: (context, child) {
                                        return AnimatedOpacity(
                                          opacity: _opacityAnimation.value,
                                          duration: _opacityAnimationController
                                              .duration!,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.sheetHandler
                                                  .withOpacity(0.4),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                            ),
                                            height: 4,
                                            width: 32,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 16),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SliverFillRemaining(
                                  child: LocateUsBranchTabViewWidget(
                                    isForMap: true,
                                    whenDealersFetch: _expandSheet,
                                    whenDealersUnoFocused: _halfCollapseSheet,
                                    branches: state.branches.branchList ?? [],
                                    dealers: state.dealers.branchList ?? [],
                                    saved: state.saved.branchList ?? [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  //? State-city location
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: LocateUsStateCityLocationWidget(
                      text: state.branches.branchList?.first.location ?? '',
                      isElevated: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
