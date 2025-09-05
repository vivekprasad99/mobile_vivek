// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchDataAdapter extends TypeAdapter<SearchData> {
  @override
  final int typeId = 0;

  @override
  SearchData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchData(
      title: fields[0] as String?,
      screenRouter: fields[1] as String?,
      type: fields[2] as String?,
      answer: fields[3] as String?,
      extra: fields[5] as dynamic,
      faqQuestion: fields[4] as String?,
      searchList: (fields[6] as List?)?.cast<String>(),
      canPop: fields[7] as bool?,
      productType: fields[8] as String?,
      productSubType: fields[9] as String?,
      category: fields[10] as String?,
      extraConversion: fields[11] as ExtraConversion?,
      isUser: fields[12] == null ? false : fields[12] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchData obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.screenRouter)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.answer)
      ..writeByte(4)
      ..write(obj.faqQuestion)
      ..writeByte(5)
      ..write(obj.extra)
      ..writeByte(6)
      ..write(obj.searchList)
      ..writeByte(7)
      ..write(obj.canPop)
      ..writeByte(8)
      ..write(obj.productType)
      ..writeByte(9)
      ..write(obj.productSubType)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.extraConversion)
      ..writeByte(12)
      ..write(obj.isUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExtraConversionAdapter extends TypeAdapter<ExtraConversion> {
  @override
  final int typeId = 1;

  @override
  ExtraConversion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtraConversion(
      intVal: fields[0] as int?,
      boolVal: fields[1] as bool?,
      stringVal: fields[2] as String?,
      prodcuctFeatureDetailRequest: fields[3] as LoansTabBarArguments?,
      servicesNavigationRequest: fields[4] as ServicesNavigationRequest?,
    );
  }

  @override
  void write(BinaryWriter writer, ExtraConversion obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.intVal)
      ..writeByte(1)
      ..write(obj.boolVal)
      ..writeByte(2)
      ..write(obj.stringVal)
      ..writeByte(3)
      ..write(obj.prodcuctFeatureDetailRequest)
      ..writeByte(4)
      ..write(obj.servicesNavigationRequest);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtraConversionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoansTabBarArgumentsAdapter extends TypeAdapter<LoansTabBarArguments> {
  @override
  final int typeId = 2;

  @override
  LoansTabBarArguments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoansTabBarArguments(
      loanTypeData: fields[0] as LoanType?,
      productType: fields[1] as String?,
      productSubType: fields[2] as String?,
      isFromSearch: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LoansTabBarArguments obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.loanTypeData)
      ..writeByte(1)
      ..write(obj.productType)
      ..writeByte(2)
      ..write(obj.productSubType)
      ..writeByte(3)
      ..write(obj.isFromSearch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoansTabBarArgumentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServicesNavigationRequestAdapter
    extends TypeAdapter<ServicesNavigationRequest> {
  @override
  final int typeId = 3;

  @override
  ServicesNavigationRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServicesNavigationRequest(
      cardName: fields[1] as String?,
      cardType: fields[2] as String?,
      isFromSearch: fields[0] as bool?,
      myProfileResponse: fields[3] as ProfileInfo?,
      addressType: fields[4] as AddressType?,
      fromRoute: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServicesNavigationRequest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isFromSearch)
      ..writeByte(1)
      ..write(obj.cardName)
      ..writeByte(2)
      ..write(obj.cardType)
      ..writeByte(3)
      ..write(obj.myProfileResponse)
      ..writeByte(4)
      ..write(obj.addressType)
      ..writeByte(5)
      ..write(obj.fromRoute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServicesNavigationRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
