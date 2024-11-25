 import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class Util {
  static Future<Uint8List?> convertXFileToUint8List(XFile xFile) async {
    Uint8List bytes = await xFile.readAsBytes();
    return bytes;
  }
}