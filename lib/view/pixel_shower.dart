import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

import '../model/asset_model.dart';

class PixelShower extends StatefulWidget {
  const PixelShower({Key? key, required this.model}) : super(key: key);

  final AssetModel model;

  @override
  State<PixelShower> createState() => _PixelShowerState();
}

class _PixelShowerState extends State<PixelShower> with SingleTickerProviderStateMixin {
  GlobalKey imageKey = GlobalKey();
  String imagePath = 'assets/map.jpg';
  img.Image? photo;
  double globalX = 0.0;
  double globalY = 0.0;
  late Animation<double> animation;
  late AnimationController animationcontroller;

  @override
  void initState() {
    super.initState();

    animationcontroller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animationcontroller.repeat();
    animation = Tween<double>(begin: 0, end: 50).animate(animationcontroller);
    animation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setBlink(widget.model.coordinates!.x!, widget.model.coordinates!.y!);
    });
  }

  @override
  void dispose() {
    animationcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Color picker"),
      ),
      body: InteractiveViewer(
        child: Stack(
          children: [
            RepaintBoundary(
              child: Image.asset(
                imagePath,
                key: imageKey,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: globalY - (animation.value / 2),
              left: globalX - (animation.value / 2),
              child: Container(
                decoration:  BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.7)),
                height: animation.value,
                width: animation.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setBlink(double x, double y) async {
    if (photo == null) {
      ByteData imageBytes = await rootBundle.load(imagePath);
      List<int> values = imageBytes.buffer.asUint8List();
      photo = null;
      photo = img.decodeImage(values);
    }

    await Future.delayed(const Duration(milliseconds: 300));

    RenderBox? box = imageKey.currentContext?.findRenderObject() as RenderBox?;
    Offset localPosition = ui.Offset(x, y);
    double widgetScale = box!.size.width / photo!.width;

    double px = (localPosition.dx * widgetScale);
    double py = (localPosition.dy * widgetScale);

    setState(() {
      globalX = px;
      globalY = py;
    });
  }
}
