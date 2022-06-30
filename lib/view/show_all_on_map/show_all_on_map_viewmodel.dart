import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

class ShowAllOnMapViewModel extends ChangeNotifier {
  String imagePath = 'assets/map2.png';
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();
  late GlobalKey currentKey;
  late RenderBox? box;
  img.Image? photo;

  void init() {
    imageKey = GlobalKey();

    Future.delayed(const Duration(milliseconds: 50), () async {
      if (photo == null) {
        await loadImageBundleBytes();
      }
      box = imageKey.currentContext?.findRenderObject() as RenderBox?;
      notifyListeners();
    });
  }

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    setImageBytes(imageBytes);
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}
