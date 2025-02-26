part of 'handler.dart';

class ShapeHandler extends PastingHandler<ShapeTool> {
  ShapeHandler(super.data);

  @override
  PreferredSizeWidget getToolbar(DocumentBloc bloc) => ColorToolbarView(
        color: data.property.color,
        onChanged: (value) {
          bloc.add(ToolsChanged({
            data: data.copyWith(
                property: data.property.copyWith(
                    color: convertOldColor(value, data.property.color))),
          }));
        },
      );

  @override
  List<PadElement> transformElements(Rect rect, String layer) {
    if (rect.isEmpty) return [];

    return [
      ShapeElement(
        firstPosition: rect.topLeft.toPoint(),
        secondPosition: rect.bottomRight.toPoint(),
        property: data.property,
        layer: layer,
      ),
    ];
  }

  @override
  double get constraintedAspectRatio => data.constrainedAspectRatio;
  @override
  double get constraintedHeight => data.constrainedHeight;
  @override
  double get constraintedWidth => data.constrainedWidth;
}
