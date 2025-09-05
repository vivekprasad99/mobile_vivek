import 'package:flutter_bloc/flutter_bloc.dart';

class DataCubit extends Cubit<String> {
  DataCubit() : super('');

  void updateData(String newData) => emit(newData);
}
