import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:butterfly_api/butterfly_api.dart';

import '../helpers/element_helper.dart';

class AssetService {
  final NoteData document;
  final Map<String, Uint8List> _cached = {};
  final Map<String, ui.Image> _images = {};

  AssetService(this.document);

  Future<ui.Image?> getImage(String path) async {
    if (_images.containsKey(path)) {
      return _images[path]!.clone();
    }
    var data = await getDataFromSource(document, path);
    if (data == null) {
      data = _cached[path];
      if (data == null) return null;
      document.setAsset(Uri.parse(path).path, data);
    }
    _cached[path] = data;
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;
    _images[path] = image;
    return image.clone();
  }

  void removeImage(String path) {
    _images.remove(path)?.dispose();
  }
}
