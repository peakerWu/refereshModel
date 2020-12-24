import 'package:referesh_model/view_models/index.dart';

class ReadModel extends RefreshViewNewModel<int> {
  @override
  Future<List<int>> loadData({int page}) async {
    List<int> _list = [];
    await Future.delayed(Duration(seconds: 2), () {
      if (page == 2) {
        _list = List.generate(10, (index) {
          return index;
        });
      } else {
        _list = List.generate(20, (index) {
          return index;
        });
      }
    });
    return _list;
  }
}
