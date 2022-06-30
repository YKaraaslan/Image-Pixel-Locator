import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/view/show_all_on_map/show_all_on_map_viewmodel.dart';
import 'dart:ui' as ui;

import '../../core/constants/enums.dart';
import '../../core/model/asset_model.dart';
import '../../core/model/global.dart';

class ShowAllOnMapView extends StatefulWidget {
  const ShowAllOnMapView({Key? key}) : super(key: key);

  @override
  State<ShowAllOnMapView> createState() => _ShowAllOnMapViewState();
}

class _ShowAllOnMapViewState extends State<ShowAllOnMapView> {
  late final ShowAllOnMapViewModel viewModel =
      context.read<ShowAllOnMapViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 5,
      child: Consumer<ShowAllOnMapViewModel>(
        builder: (context, value, child) => Scaffold(
          body: Center(
            child: FittedBox(
              child: value.photo?.width.toDouble() != null
                  ? SizedBox(
                      width: value.photo?.width.toDouble() ?? 100,
                      height: value.photo?.height.toDouble() ?? 100,
                      child: RepaintBoundary(
                        key: viewModel.paintKey,
                        child: CustomPaint(
                          foregroundPainter: LinePainter(
                            models: Global.model ?? [],
                          ),
                          child: Image.asset(
                            viewModel.imagePath,
                            key: viewModel.imageKey,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  const LinePainter({Key? key, required this.models});
  final List<GameModel> models;

  void drawRectangle(Canvas canvas, Machines model) {
    final paint = Paint()
      ..strokeWidth = 3
      ..color = Colors.red
      ..style = ui.PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(
        Rect.fromPoints(
            Offset(model.coordinates!.startX!, model.coordinates!.startY!),
            Offset(model.coordinates!.endX!, model.coordinates!.endY!)),
        paint);
  }

  void drawCircle(Canvas canvas, Machines model) {
    final paint = Paint()
      ..strokeWidth = 3
      ..color = Colors.red
      ..style = ui.PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
        Offset(model.coordinates!.startX!, model.coordinates!.startY!),
        15,
        paint);
  }

  void drawLine(Canvas canvas, Machines model) {
    final paint = Paint()
      ..strokeWidth = 3
      ..color = Colors.red
      ..style = ui.PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(model.coordinates!.startX!, model.coordinates!.startY!),
        Offset(model.coordinates!.endX!, model.coordinates!.endY!),
        paint);
  }

  void drawPoint(Canvas canvas, Machines model) {
    final paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.red
      ..style = ui.PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(model.coordinates!.startX!, model.coordinates!.startY!),
        Offset(model.coordinates!.startX!, model.coordinates!.startY!),
        paint);
  }

  void rotate(
      {required Canvas canvas,
      required double cx,
      required double cy,
      required double angle}) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var game in models) {
      for (var machine in game.machines!) {
        if (machine!.drawType == Types.rectangle.getName()) {
          drawRectangle(canvas, machine);
        } else if (machine.drawType == Types.circle.getName()) {
          drawCircle(canvas, machine);
        } else if (machine.drawType == Types.line.getName()) {
          drawLine(canvas, machine);
        } else if (machine.drawType == Types.point.getName()) {
          drawPoint(canvas, machine);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
