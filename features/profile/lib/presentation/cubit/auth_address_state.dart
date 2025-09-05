part of 'auth_address_cubit.dart';

abstract class AddressAuthenticationState extends Equatable {}

class AddressAuthenticationInitial extends AddressAuthenticationState {
  @override
  List<Object?> get props => [];
}

class DropDownState extends AddressAuthenticationState {
  final String name;

  DropDownState({required this.name});

  @override
  List<Object?> get props => [name];
}
