import 'package:flutter/cupertino.dart';

import '../model/asset_model.dart';
import '../model/global.dart';
import '../service/network_manager.dart';

class ViewModel extends ChangeNotifier {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController textEditingController;
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
        searchList = Global.model!.where((element) => element.name!.toLowerCase().contains(text.toLowerCase())).toList();
      } catch (e) {
        searchList = [];
      }
    }
    notifyListeners();
  }
}
