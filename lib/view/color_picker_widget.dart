import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

import '../model/asset_model.dart';

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({Key? key, required this.model}) : super(key: key);
  final AssetModel model;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  String imagePath = 'assets/map.jpg';
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();
  late GlobalKey currentKey;
  final StreamController<Color> _stateController = StreamController<Color>();
  img.Image? photo;
  late RenderBox? box;
  double globalX = 0;
  double globalY = 0;

  @override
  void initState() {
    super.initState();
    currentKey = imageKey;

    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        box = currentKey.currentContext?.findRenderObject() as RenderBox?;
      });
      setBlink(widget.model.coordinates!.x!, widget.model.coordinates!.y!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: AppBar(
          title: const Text("Color picker"),
        ),
        body: StreamBuilder(
          initialData: Colors.green[500],
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            Color selectedColor = Colors.green;
            if (snapshot.data != null) {
              selectedColor = snapshot.data as Color;
            }
            return InteractiveViewer(
              child: Stack(
                children: [
                  RepaintBoundary(
                    key: paintKey,
                    child: GestureDetector(
                      onPanDown: (details) {
                        searchPixel(details.globalPosition);
                      },
                      onPanUpdate: (details) {
                        searchPixel(details.globalPosition);
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            imagePath,
                            key: imageKey,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: globalX,
                            left: globalY,
                            child: const CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(70),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedColor,
                      border: Border.all(width: 2.0, color: Colors.white),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 114,
                    top: 95,
                    child: Text(
                      '$selectedColor',
                      style: const TextStyle(color: Colors.white, backgroundColor: Colors.black54),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    Offset localPosition = box!.globalToLocal(globalPosition);

    double widgetScale = box!.size.width / photo!.width;
    double px = (localPosition.dx / widgetScale);
    double py = (localPosition.dy / widgetScale);

    int pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    _stateController.add(Color(hex));
  }

  void setBlink(double x, double y) async {
    if (photo == null) {
      await (loadImageBundleBytes());
    }

    Offset localPosition = ui.Offset(x, y);
    double widgetScale = box!.size.width / photo!.width;

    double px = (localPosition.dx / widgetScale);
    double py = (localPosition.dy / widgetScale);

    setState(() {
      globalX = px;
      globalY = py;
    });
  }

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image capture = await boxPaint.toImage();
    ByteData? imageBytes = await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes!);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}
