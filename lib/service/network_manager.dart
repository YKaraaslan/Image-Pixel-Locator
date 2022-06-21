import 'dart:io';

import 'package:dio/dio.dart';

import '../model/asset_model.dart';

abstract class INetworkManager {
  INetworkManager();
  late List<GameModel> returnType;
  final String _path = '';
  Future<List<GameModel>?> getModels();
}

class NetworkManager extends INetworkManager {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.104:8080/',
  ));

  Future<dynamic> _getDioRequest() async {
    final response = await dio.get(_path);

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    }
  }

  @override
  Future<List<GameModel>?> getModels() async {
    final response = await _getDioRequest();
    returnType = [];
    if (response is List) {
      return response.map((e) {
        return GameModel.fromMap(e);
      }).toList();
    } else {
      return [];
    }
  }
}
