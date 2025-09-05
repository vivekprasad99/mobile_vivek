part of 'foreclosure_cubit.dart';

@immutable
sealed class ForeclosureState extends Equatable {}

final class ForeclosureInitial extends ForeclosureState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ForeclosureState {
  final bool isloading;

  LoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class ForeclosureGetLoansSuccessState extends ForeclosureState {
  final GetLoansResponse response;

  ForeclosureGetLoansSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class SelectedLoanItemState extends ForeclosureState {
  final LoanItem? loanItem;

  SelectedLoanItemState({required this.loanItem});

  @override
  List<Object?> get props => [loanItem];
}

class ForeclosureGetLoansFailureState extends ForeclosureState {
  final Failure failure;

  ForeclosureGetLoansFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetLoanDetailsSuccessState extends ForeclosureState {
  final GetLoanDetailsResponse response;
  final LoanItem selectLoanItem;
  GetLoanDetailsSuccessState(
      {required this.response, required this.selectLoanItem});

  @override
  List<Object?> get props => [response];
}

class GetLoanDetailsFailureState extends ForeclosureState {
  final Failure failure;

  GetLoanDetailsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetReasonsSuccessState extends ForeclosureState {
  final List<Reasons> response;

  GetReasonsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetReasonsFailureState extends ForeclosureState {
  final Failure failure;

  GetReasonsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetOffersSuccessState extends ForeclosureState {
  final GetOffersResponse response;

  GetOffersSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetOffersFailureState extends ForeclosureState {
  final Failure failure;

  GetOffersFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class PreApprovedOffersSuccessState extends ForeclosureState {
  final GetOffersResponse response;

  PreApprovedOffersSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class PreApprovedOffersFailureState extends ForeclosureState {
  final Failure failure;

  PreApprovedOffersFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class FundOfSourceSuccessState extends ForeclosureState {
  final List<FundOfSource> response;

  FundOfSourceSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FundOfSourceFailureState extends ForeclosureState {
  final Failure failure;

  FundOfSourceFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetForeClosureDetailsSuccessState extends ForeclosureState {
  final GetForeClosureDetailsResponse response;

  GetForeClosureDetailsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetForeClosureDetailsFailureState extends ForeclosureState {
  final Failure failure;

  GetForeClosureDetailsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class CreateForeclosureSRSuccessState extends ForeclosureState {
  final ServiceRequestResponse response;

  CreateForeclosureSRSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class CreateForeclosureSRFailureState extends ForeclosureState {
  final Failure failure;

  CreateForeclosureSRFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class TextFieldState extends ForeclosureState {
  final String? text;

  TextFieldState({required this.text});

  @override
  List<Object?> get props => [text];
}

class DropDownState extends ForeclosureState {
  final Reasons resaon;
  final String name;

  DropDownState({required this.resaon, required this.name});

  @override
  List<Object?> get props => [resaon, name];
}

class OfferButtonState extends ForeclosureState {
  final bool offer;

  OfferButtonState({required this.offer});

  @override
  List<Object?> get props {
    return [offer];
  }
}

class OfferRejectedState extends ForeclosureState {
  OfferRejectedState();

  @override
  List<Object?> get props {
    return [];
  }
}
class ShowDetailsState extends ForeclosureState {
  final bool showDetails;
  ShowDetailsState(this.showDetails);

  @override
  List<Object?> get props {
    return [showDetails];
  }
}