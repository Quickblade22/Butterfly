part of 'texture.dart';

void drawPatternTextureOnCanvas(PatternTexture texture, Canvas canvas,
    double scale, Offset offset, Size size) {
  canvas.drawColor(Color(texture.boxColor), BlendMode.srcOver);
  if (texture.boxWidth > 0 && texture.boxXCount > 0) {
    var relativeWidth = texture.boxWidth * scale;
    var relativeSpace = texture.boxXSpace * scale;
    int xCount =
        (offset.dx / (texture.boxWidth * texture.boxXCount + texture.boxXSpace))
                .floor() +
            1;
    double x =
        -xCount * (texture.boxWidth * texture.boxXCount + texture.boxXSpace) +
            offset.dx;
    x *= scale;

    int count = 0;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          Paint()
            ..strokeWidth = texture.boxXStroke * scale
            ..color = Color(texture.boxXColor));
      count++;
      if (count >= texture.boxXCount) {
        count = 0;
        x += relativeSpace;
      }
      x += relativeWidth;
    }
  }
  if (texture.boxHeight > 0 && texture.boxYCount > 0) {
    var relativeHeight = texture.boxHeight * scale;
    var relativeSpace = texture.boxYSpace * scale;
    int yCount = (offset.dy /
                (texture.boxHeight * texture.boxYCount + texture.boxYSpace))
            .floor() +
        1;
    double y =
        -yCount * (texture.boxHeight * texture.boxYCount + texture.boxYSpace) +
            offset.dy;
    y *= scale;

    int count = 0;
    while (y < size.height) {
      canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          Paint()
            ..strokeWidth = texture.boxYStroke * scale
            ..color = Color(texture.boxYColor));
      count++;
      if (count >= texture.boxYCount) {
        count = 0;
        y += relativeSpace;
      }
      y += relativeHeight;
    }
  }
}

void drawPatternTextureOnSvg(
    PatternTexture texture, XmlDocument xml, Offset offset, Size size) {
  var g =
      xml.getOrCreateElement('svg').createElement('g', id: 'box-background');

  g.createElement('rect', attributes: {
    'x': '${offset.dx}px',
    'y': '${offset.dy}px',
    'width': '${size.width}px',
    'height': '${size.height}px',
    'fill': texture.boxColor.toHexColor(),
  });
  if (texture.boxWidth > 0 && texture.boxXCount > 0) {
    int xCount =
        (offset.dx / (texture.boxWidth * texture.boxXCount + texture.boxXSpace))
                .floor() +
            1;
    double x =
        -xCount * (texture.boxWidth * texture.boxXCount + texture.boxXSpace) +
            offset.dx;

    int count = 0;
    while (x < size.width) {
      g.createElement('line', attributes: {
        'x1': '${x + offset.dx}px',
        'y1': '${offset.dy}px',
        'x2': '${x + offset.dx}px',
        'y2': '${offset.dy + size.height}px',
        'stroke': texture.boxXColor.toHexColor(),
        'stroke-width': '${texture.boxXStroke}'
      });
      count++;
      if (count >= texture.boxXCount) {
        count = 0;
        x += texture.boxXSpace;
      }
      x += texture.boxWidth;
    }
  }
  if (texture.boxHeight > 0 && texture.boxYCount > 0) {
    int yCount = (offset.dy /
                (texture.boxHeight * texture.boxYCount + texture.boxYSpace))
            .floor() +
        1;
    double y =
        -yCount * (texture.boxHeight * texture.boxYCount + texture.boxYSpace) +
            offset.dy;

    int count = 0;
    while (y < size.height) {
      g.createElement('line', attributes: {
        'x1': '${offset.dx}px',
        'y1': '${y + offset.dy}px',
        'x2': '${offset.dx + size.width}px',
        'y2': '${y + offset.dy}px',
        'stroke': texture.boxYColor.toHexColor(),
        'stroke-width': '${texture.boxYStroke}'
      });
      count++;
      if (count >= texture.boxYCount) {
        count = 0;
        y += texture.boxYSpace;
      }
      y += texture.boxHeight;
    }
  }
}
