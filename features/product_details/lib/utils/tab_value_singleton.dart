class TabValueSingleton {

  TabValueSingleton._privateConstructor();
  static final TabValueSingleton _instance = TabValueSingleton._privateConstructor();
  static TabValueSingleton get instance => _instance;

  int? _savedValue;

  void saveValue(int value) {
    _savedValue = value;
  }

  int getSavedValue() {
    return _savedValue!;
  }
}
