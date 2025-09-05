
import 'package:common/features/search/data/model/search_response.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchViewModel {
 Future<void> storeSearchData(List<SearchData> dataList) async {
  var box = await Hive.openBox<SearchData>('searchData');
  await box.clear();
  await box.addAll(dataList);
  await box.close();
  }

  Future<List<SearchData>> getSearchData() async {
  var box = await Hive.openBox<SearchData>('searchData');
  List<SearchData> dataList = box.values.toList();
  await box.close();
  return dataList;
}
}

