import 'dart:ui' as ui;

import 'package:butterfly/renderers/renderer.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CameraViewport extends Equatable {
  final ui.Image? image;
  final List<Renderer<Background>> backgrounds;
  final UtilitiesRenderer utilities;
  final List<Renderer<PadElement>> bakedElements,
      unbakedElements,
      visibleElements;
  final int? width, height;
  final double pixelRatio;
  final double scale;
  final double x, y;

  const CameraViewport.unbaked(this.utilities,
      [this.backgrounds = const [],
      this.unbakedElements = const [],
      List<Renderer<PadElement>>? visibleElements])
      : image = null,
        scale = 1,
        width = null,
        height = null,
        bakedElements = const [],
        pixelRatio = 1,
        x = 0,
        y = 0,
        visibleElements = visibleElements ?? unbakedElements;

  const CameraViewport.baked(this.utilities,
      {this.backgrounds = const [],
      required this.image,
      required this.width,
      required this.height,
      required this.pixelRatio,
      this.bakedElements = const [],
      this.unbakedElements = const [],
      required this.visibleElements,
      this.scale = 1,
      this.x = 0,
      this.y = 0});

  get center => null;

  ui.Offset toOffset() => ui.Offset(x, y);

  ui.Size toSize() => ui.Size(width?.toDouble() ?? 0, height?.toDouble() ?? 0);

  bool hasSameViewport(CameraViewport other) {
    return other.width == width &&
        other.height == height &&
        other.scale == scale &&
        other.x == x &&
        other.y == y;
  }

  CameraViewport withUnbaked(List<Renderer<PadElement>> unbakedElements) =>
      CameraViewport.baked(utilities,
          backgrounds: backgrounds,
          image: image,
          width: width,
          height: height,
          scale: scale,
          unbakedElements: unbakedElements,
          bakedElements: bakedElements,
          pixelRatio: pixelRatio,
          visibleElements: List<Renderer<PadElement>>.from(visibleElements)
            ..addAll(unbakedElements),
          x: x,
          y: y);

  CameraViewport unbake({
    List<Renderer<Background>>? backgrounds,
    UtilitiesRenderer? utilities,
    List<Renderer<PadElement>>? unbakedElements,
    List<Renderer<PadElement>>? visibleElements,
  }) =>
      CameraViewport.unbaked(
          utilities ?? this.utilities,
          backgrounds ?? this.backgrounds,
          unbakedElements ??
              (List<Renderer<PadElement>>.from(this.unbakedElements)
                ..addAll(bakedElements)),
          visibleElements ??
              unbakedElements ??
              (List<Renderer<PadElement>>.from(this.unbakedElements)
                ..addAll(bakedElements)));

  CameraViewport bake({
    required ui.Image image,
    required int width,
    required int height,
    required double pixelRatio,
    List<Renderer<PadElement>> bakedElements = const [],
    List<Renderer<PadElement>> unbakedElements = const [],
    required List<Renderer<PadElement>> visibleElements,
    double scale = 1,
    double x = 0,
    double y = 0,
  }) =>
      CameraViewport.baked(utilities,
          backgrounds: backgrounds,
          image: image,
          width: width,
          height: height,
          scale: scale,
          pixelRatio: pixelRatio,
          bakedElements: bakedElements,
          unbakedElements: unbakedElements,
          x: x,
          y: y,
          visibleElements: visibleElements);

  CameraViewport withBackgrounds(List<Renderer<Background>> backgrounds) =>
      CameraViewport.baked(utilities,
          backgrounds: backgrounds,
          pixelRatio: pixelRatio,
          image: image,
          width: width,
          height: height,
          scale: scale,
          bakedElements: bakedElements,
          unbakedElements: unbakedElements,
          x: x,
          y: y,
          visibleElements: visibleElements);

  CameraViewport withUtilities(UtilitiesRenderer utilities) =>
      CameraViewport.baked(utilities,
          backgrounds: backgrounds,
          pixelRatio: pixelRatio,
          image: image,
          width: width,
          height: height,
          scale: scale,
          bakedElements: bakedElements,
          unbakedElements: unbakedElements,
          x: x,
          y: y,
          visibleElements: visibleElements);

  @override
  List<Object?> get props => [
        image,
        backgrounds,
        bakedElements,
        unbakedElements,
        width,
        height,
        scale,
        x,
        y,
        pixelRatio,
        visibleElements,
        utilities,
      ];
}
