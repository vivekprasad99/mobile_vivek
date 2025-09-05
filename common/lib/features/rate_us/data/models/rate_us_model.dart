import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:equatable/equatable.dart';
// ignore_for_file: must_be_immutable
class RateUsModel extends Equatable {
  final String? description;
  final String? image;
  final String? fillColorImage;
  final int? ratingNum;
  bool isSelected;

  RateUsModel(
      {required this.description,
      required this.image,
      required this.fillColorImage,
      required this.ratingNum,
      this.isSelected = false,});

  @override
  List<Object?> get props =>
      [description, image, fillColorImage, ratingNum, isSelected];
}

final rateUsList = [
  RateUsModel(
    description: labelUnhappy,
    image: ImageConstant.imgSentimentDissatisfiedLight,
    fillColorImage: ImageConstant.imgSentimentDissatisfiedLightFillup,
    ratingNum: 1,
  ),
  RateUsModel(
    description: labelOkay,
    image: ImageConstant.imgSentimentNeutralLight,
    fillColorImage: ImageConstant.imgSentimentNeutralLightFillup,
    ratingNum: 2,
  ),
  RateUsModel(
    description: labelHappy,
    image: ImageConstant.imgSentimentSatisfiedLight,
    fillColorImage: ImageConstant.imgSentimentSatisfiedLightFillup,
    ratingNum: 3,
  ),
];
