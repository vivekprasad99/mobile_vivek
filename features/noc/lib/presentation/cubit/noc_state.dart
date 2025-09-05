part of 'noc_cubit.dart';

@immutable
sealed class NocState extends Equatable {}

final class NocInitial extends NocState {
  @override
  List<Object?> get props => [];
}

final class UpdateRcInitState extends NocState {
  @override
  List<Object?> get props => [];
}

final class LoadingState extends NocState {
  @override
  List<Object?> get props => [];
}

final class UpdateRCLoadingState extends NocState {
  @override
  List<Object?> get props => [];
}

final class GetNocDetailsSuccessState extends NocState {
  final NocDetailsResponse response;
  GetNocDetailsSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

final class GetNocDetailsFailureState extends NocState {
  final Failure failure;
  GetNocDetailsFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

// final class UpdateRcDetailsSuccessState extends NocState {
//   final NocDetailsResponse response;
//   UpdateRcDetailsSuccessState({required this.response});
//   @override
//   List<Object?> get props => [response];
// }

final class UpdateRcDetailsFailureState extends NocState {
  final Failure failure;
  UpdateRcDetailsFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class GreenChannelValidationSuccessState extends NocState {
  final GreenChannelValidationResp response;
  final LoanData data;
  GreenChannelValidationSuccessState({
    required this.response,
    required this.data,
  });
  @override
  List<Object?> get props => [response, data];
}

final class GreenChannelValidationFailureState extends NocState {
  final Failure failure;
  GreenChannelValidationFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class FinanceMasterSuccessState extends NocState {
  final GetFinacerNamesResp response;
  FinanceMasterSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

final class FinanceMasterSFailureState extends NocState {
  final Failure failure;
  FinanceMasterSFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class GetLoansListSuccessState extends NocState {
  final GetLoanListResp response;
  final List<LoanData>? vehicleLoans;
  final List<LoanData>? rcUpdateLoans;
  GetLoansListSuccessState(
      {required this.response,
      required this.vehicleLoans,
      required this.rcUpdateLoans});
  @override
  List<Object?> get props => [response];
}

final class GetLoansListFailureState extends NocState {
  final Failure failure;
  GetLoansListFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class GetVahanDetailsSuccessState extends NocState {
  final GetVahanDetailsResp response;
  GetVahanDetailsSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

final class GetVahanDetailsFailureState extends NocState {
  final Failure failure;
  GetVahanDetailsFailureState({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class SelectNocItem extends NocState {
  final LoanData? loanData;
  final String query;
  SelectNocItem({required this.loanData, required this.query});
  @override
  List<Object?> get props => [loanData, query];
}

final class SelectQueryState extends NocState {
  final String query;

  SelectQueryState({required this.query});
  @override
  List<Object?> get props => [query];
}

final class GreenChannelLoading extends NocState {
  @override
  List<Object?> get props => [];
}

final class DownloadNocSuccessState extends NocState {
  final DlNocResp response;
  DownloadNocSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

final class DownloadNocFailuretate extends NocState {
  final Failure failure;
  DownloadNocFailuretate({required this.failure});
  @override
  List<Object?> get props => [failure];
}

final class DownloadNocLoading extends NocState {
  @override
  List<Object?> get props => [];
}

final class PreferredMethodState extends NocState {
  final String loanNumber;
  final PreferredMethod preferredMethod;

  PreferredMethodState({this.preferredMethod = PreferredMethod.branch,required this.loanNumber,});

  @override
  List<Object?> get props => [preferredMethod,loanNumber];
}

final class SelectedPrefferedAddressState<T> extends NocState {
  final T? address;
  final String? addressType;
  final String loanNumber;

  SelectedPrefferedAddressState({
    this.address,
    this.addressType,
    required this.loanNumber,
  });

  @override
  List<Object?> get props => [address, addressType,loanNumber];
}
final class SaveDeliverySuccessState<T>  extends NocState{
  final T? address;
  final SaveDeliveryResp response;

  SaveDeliverySuccessState({required this.response,this.address,});

  @override
  List<Object?> get props => [response,address];

}

final class SaveDeliveryFailuretate extends NocState {
  final Failure failure;
  SaveDeliveryFailuretate({required this.failure});
  @override
  List<Object?> get props => [failure];
}
 final class SaveDeliveryLoadingState extends NocState{
  final bool isLoading;
  SaveDeliveryLoadingState({required this.isLoading});
  @override
  List<Object?> get props => [isLoading];

 }