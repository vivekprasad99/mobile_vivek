part of 'help_cubit.dart';

@immutable
sealed class HelpState {}

final class HelpInitial extends HelpState {}

class LoadingState extends HelpState {
  final bool isLoading;
  LoadingState({required this.isLoading});
}

class LoadedState extends HelpState {
  final List<FAQ> faqs;
  final List<SubType> subType;
  final List<String> headers;
  final List<String> productSubTypeName;

  LoadedState({required this.faqs, required this.subType,required this.headers,required this.productSubTypeName});

  List<Object> get props => [faqs, headers,subType,productSubTypeName];
}

class ErrorState extends HelpState {
  final String message;
  ErrorState({required this.message});

  List<Object> get props => [message];
}
class FailureState extends HelpState {
  final Failure error;
  FailureState({required this.error});

  List<Object> get props => [error];
}
