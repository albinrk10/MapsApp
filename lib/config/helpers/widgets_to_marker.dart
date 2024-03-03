import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/presentation/ui/ui.dart';

Future<BitmapDescriptor> getStarCustomMarker(
    int minutes, String destination) async {
  final recoder = ui.PictureRecorder();
  final canvas = ui.Canvas(recoder);
  const size = ui.Size(350, 150);

  final starMarker = StartMarkerPainter(
    minutes: minutes,
    destination: destination,
  );
  starMarker.paint(canvas, size);

  final picture = recoder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getEndCustomMarker(
    int kilometers, String destination) async {
  final recoder = ui.PictureRecorder();
  final canvas = ui.Canvas(recoder);
  const size = ui.Size(350, 150);

  final starMarker = EndMarkerPainter(
    kilometers : kilometers,
    destination: destination, 
  );
  starMarker.paint(canvas, size);

  final picture = recoder.endRecording();
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

