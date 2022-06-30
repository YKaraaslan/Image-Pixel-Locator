import 'package:flutter/cupertino.dart';

import '../core/model/asset_model.dart';
import '../core/model/global.dart';
import '../core/service/network_manager.dart';

class ViewModel extends ChangeNotifier {
  late GlobalKey<FormState> formKey;
  late TextEditingController textEditingController;
  late List<GameModel> searchList;

  Future<void> getModel() async {
    Global.model = await NetworkManager().getModels();
    searchList = Global.model!;
    notifyListeners();
  }

  void onChangeMethod(String text) {
    if (text.isEmpty) {
      searchList = Global.model!;
    } else {
      try {
        searchList = Global.model!
            .where((element) =>
                element.name!.toLowerCase().contains(text.toLowerCase()))
            .toList();
      } catch (e) {
        searchList = [];
      }
    }
    notifyListeners();
  }
}
