import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_address_state.dart';

class AddressAuthenticationCubit extends Cubit<AddressAuthenticationState> {
  AddressAuthenticationCubit() : super(AddressAuthenticationInitial());

  void selectAuthType(String name) {
    emit(DropDownState(name: name));
  }
}
