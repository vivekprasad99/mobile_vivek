import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/faq_response.dart';

abstract class FAQState extends Equatable {}

class FAQInitial extends FAQState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends FAQState {
  final bool isLoading;
  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class FAQSuccessState extends FAQState {
  final FAQResponse response;
  FAQSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FAQFailureState extends FAQState {
  final Failure error;
  FAQFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class DropDownState extends FAQState {
  final SubTypes category;
  final String name;

  DropDownState({required this.category, required this.name});

  @override
  List<Object?> get props => [category, name];
}

class FAQMicActiveState extends FAQState {
  final bool showMic;

  FAQMicActiveState({
     required this.showMic,
  });

   @override
  List<Object?> get props => [showMic];
}

class SearchLoaded extends FAQState {
  final List<Faq> results;
  final List<Videos> videos;

  SearchLoaded({required this.results, required this.videos});

  @override
  List<Object> get props => [results];
}
