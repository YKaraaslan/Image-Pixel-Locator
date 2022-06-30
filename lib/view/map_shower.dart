import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

import '../core/model/asset_model.dart';

class MapShower extends StatefulWidget {
  const MapShower({Key? key, required this.model}) : super(key: key);

  final GameModel model;

  @override
  State<MapShower> createState() => _MapShowerState();
}

class _MapShowerState extends State<MapShower> with TickerProviderStateMixin {
  GlobalKey imageKey = GlobalKey();
  String imagePath = 'assets/map2.png';
  img.Image? photo;
  late Animation<double> sizeAnimation, opacityAnimation;
  late AnimationController sizeAnimationController, opacityAnimationController;
  late List<Widget> machines;

  @override
  void initState() {
    super.initState();
    machines = [];

    sizeAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    sizeAnimationController.repeat();
    sizeAnimation =
        Tween<double>(begin: 0, end: 40).animate(sizeAnimationController);
    sizeAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    opacityAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    opacityAnimationController.repeat();
    opacityAnimation =
        Tween<double>(begin: 1, end: 0.3).animate(opacityAnimationController);
    opacityAnimation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    sizeAnimationController.dispose();
    opacityAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      setBlink(widget.model);
      return body();
    });
  }

  Widget photoWidget() {
    return RepaintBoundary(
      child: Image.asset(
        imagePath,
        key: imageKey,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget body() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Color picker"),
      ),
      body: InteractiveViewer(
        child: Stack(children: machines),
      ),
    );
  }

  Widget positionedWidget(Machines model, double x, double y) {
    return Positioned(
      top: y - (sizeAnimation.value / 2),
      left: x - (sizeAnimation.value / 2),
      child: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(model.name ?? 'Title'),
              content: Text(model.description ?? "Message"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
        child: Opacity(
          opacity: opacityAnimation.value,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.red.withOpacity(0.7)),
            height: sizeAnimation.value,
            width: sizeAnimation.value,
          ),
        ),
      ),
    );
  }

  Future<void> setBlink(GameModel model) async {
    if (photo == null) {
      ByteData imageBytes = await rootBundle.load(imagePath);
      List<int> values = imageBytes.buffer.asUint8List();
      photo = null;
      photo = img.decodeImage(values);
    }

    await Future.delayed(const Duration(milliseconds: 300));

    RenderBox? box = imageKey.currentContext?.findRenderObject() as RenderBox?;
    machines = [];
    machines.add(photoWidget());

    for (var machine in model.machines!) {
      Offset localPosition = ui.Offset(
          machine!.coordinates!.startX!, machine.coordinates!.startY!);

      if (box != null) {
        double widgetScale = box.size.width / photo!.width;

        double px = (localPosition.dx * widgetScale);
        double py = (localPosition.dy * widgetScale);

        machines.add(positionedWidget(machine, px, py));
      }
    }

    if (box != null) {
      setState(() {});
    }
  }
}
