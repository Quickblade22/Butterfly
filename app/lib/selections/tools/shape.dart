part of '../selection.dart';

class ShapeToolSelection extends ToolSelection<ShapeTool> {
  ShapeToolSelection(super.selected);

  @override
  List<Widget> buildProperties(BuildContext context) {
    final tool = selected.first;
    final property = tool.property;
    void updateProperty(ShapeProperty property) => update(
        context, selected.map((e) => e.copyWith(property: property)).toList());
    return [
      ...super.buildProperties(context),
      ExactSlider(
          header: Text(AppLocalizations.of(context).width),
          value: tool.constrainedWidth,
          min: 0,
          max: 500,
          defaultValue: 0,
          onChangeEnd: (value) => update(
              context,
              selected
                  .map((e) => e.copyWith(constrainedWidth: value))
                  .toList())),
      ExactSlider(
          header: Text(AppLocalizations.of(context).height),
          value: tool.constrainedHeight,
          min: 0,
          max: 500,
          defaultValue: 0,
          onChangeEnd: (value) => update(
              context,
              selected
                  .map((e) => e.copyWith(constrainedHeight: value))
                  .toList())),
      ExactSlider(
          header: Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context).aspectRatio,
                  textAlign: TextAlign.center,
                ),
              ),
              MenuAnchor(
                builder: defaultMenuButton(),
                menuChildren: AspectRatioPreset.values
                    .map((e) => MenuItemButton(
                          child: Text(e.getLocalizedName(context)),
                          onPressed: () => update(
                              context,
                              selected
                                  .map((c) => c.copyWith(
                                      constrainedAspectRatio: e.ratio))
                                  .toList()),
                        ))
                    .toList(),
              )
            ],
          ),
          value: tool.constrainedAspectRatio,
          min: 0,
          max: 10,
          defaultValue: 0,
          onChangeEnd: (value) => update(
              context,
              selected
                  .map((e) => e.copyWith(constrainedAspectRatio: value))
                  .toList())),
      ExactSlider(
          header: Text(AppLocalizations.of(context).strokeWidth),
          value: tool.property.strokeWidth,
          min: 0,
          max: 70,
          defaultValue: 5,
          onChangeEnd: (value) => update(
              context,
              selected
                  .map((e) => e.copyWith(
                      property: e.property.copyWith(strokeWidth: value)))
                  .toList())),
      const SizedBox(height: 50),
      ColorField(
        value: Color(tool.property.color),
        onChanged: (color) => update(
            context,
            selected
                .map((e) => e.copyWith(
                    property: e.property.copyWith(color: color.value)))
                .toList()),
        title: Text(AppLocalizations.of(context).color),
      ),
      ExactSlider(
        value: Color(property.color).alpha.toDouble(),
        header: Text(AppLocalizations.of(context).alpha),
        fractionDigits: 0,
        max: 255,
        min: 0,
        defaultValue: 255,
        onChangeEnd: (value) => update(
            context,
            selected
                .map((e) => e.copyWith(
                    property: e.property.copyWith(
                        color: convertColor(property.color, value.toInt()))))
                .toList()),
      ),
      ShapeView(
          shape: property.shape,
          onChanged: (shape) =>
              updateProperty(property.copyWith(shape: shape))),
      const SizedBox(height: 15),
      CheckboxListTile(
          value: tool.zoomDependent,
          title: Text(AppLocalizations.of(context).zoomDependent),
          onChanged: (value) => update(
              context,
              selected
                  .map((e) =>
                      e.copyWith(zoomDependent: value ?? tool.zoomDependent))
                  .toList())),
    ];
  }

  @override
  Selection insert(dynamic element) {
    if (element is ShapeTool) {
      return ShapeToolSelection([...selected, element]);
    }
    return super.insert(element);
  }

  @override
  IconGetter get icon => selected.first.property.shape.icon;
}

class ShapeView extends StatefulWidget {
  final PathShape shape;
  final ValueChanged<PathShape> onChanged;
  const ShapeView({super.key, required this.shape, required this.onChanged});

  @override
  State<ShapeView> createState() => _ShapeViewState();
}

class _ShapeViewState extends State<ShapeView> {
  late PathShape currentShape;
  bool oShapeed = false;

  @override
  void initState() {
    super.initState();
    currentShape = widget.shape;
  }

  void _onShapeChanged(PathShape shape) {
    setState(() {
      currentShape = shape;
    });
    widget.onChanged(shape);
  }

  Widget _buildShapeView() {
    final current = currentShape;
    if (current is CircleShape) {
      return _CircleShapeView(shape: current, onChanged: _onShapeChanged);
    }
    if (current is RectangleShape) {
      return _RectangleShapeView(shape: current, onChanged: _onShapeChanged);
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    Widget shapeView = _buildShapeView();

    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          oShapeed = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: oShapeed,
          headerBuilder: (context, expanded) => ListTile(
            title: Text(AppLocalizations.of(context).shape),
            trailing: DropdownButton<String>(
              value: currentShape.runtimeType.toString(),
              items: [PathShape.circle, PathShape.rectangle, PathShape.line]
                  .map((e) {
                var shape = e();
                return DropdownMenuItem<String>(
                  value: shape.runtimeType.toString(),
                  child: Row(children: [
                    PhosphorIcon(shape.icon(PhosphorIconsStyle.light)),
                    const SizedBox(width: 8),
                    Text(shape.getLocalizedName(context)),
                  ]),
                  onTap: () => _onShapeChanged(shape),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ),
          body: shapeView,
        )
      ],
    );
  }
}

class _CircleShapeView extends StatelessWidget {
  final CircleShape shape;
  final ValueChanged<CircleShape> onChanged;
  const _CircleShapeView({required this.shape, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ColorField(
        value: Color(shape.fillColor),
        title: Text(AppLocalizations.of(context).fill),
        leading: const PhosphorIcon(PhosphorIconsLight.paintBucket),
        defaultColor: Colors.transparent,
        onChanged: (color) => onChanged(shape.copyWith(fillColor: color.value)),
      ),
      ExactSlider(
        value: Color(shape.fillColor).alpha.toDouble(),
        header: Text(AppLocalizations.of(context).alpha),
        fractionDigits: 0,
        max: 255,
        min: 0,
        defaultValue: 255,
        onChangeEnd: (value) => onChanged(shape.copyWith(
            fillColor: convertColor(shape.fillColor, value.toInt()))),
      )
    ]);
  }
}

class _RectangleShapeView extends StatefulWidget {
  final RectangleShape shape;
  final ValueChanged<RectangleShape> onChanged;
  const _RectangleShapeView({required this.shape, required this.onChanged});

  @override
  State<_RectangleShapeView> createState() => _RectangleShapeViewState();
}

class _RectangleShapeViewState extends State<_RectangleShapeView> {
  bool cornerOShapeed = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ColorField(
        title: Text(AppLocalizations.of(context).fill),
        leading: const PhosphorIcon(PhosphorIconsLight.paintBucket),
        value: Color(widget.shape.fillColor),
        defaultColor: Colors.transparent,
        onChanged: (color) =>
            widget.onChanged(widget.shape.copyWith(fillColor: color.value)),
      ),
      ExactSlider(
        value: Color(widget.shape.fillColor).alpha.toDouble(),
        header: Text(AppLocalizations.of(context).alpha),
        fractionDigits: 0,
        max: 255,
        min: 0,
        defaultValue: 255,
        onChangeEnd: (value) => widget.onChanged(widget.shape.copyWith(
            fillColor: convertColor(widget.shape.fillColor, value.toInt()))),
      ),
      ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            cornerOShapeed = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) => ListTile(
              title: Text(AppLocalizations.of(context).cornerRadius),
            ),
            isExpanded: cornerOShapeed,
            body: Column(children: [
              ExactSlider(
                defaultValue: 0,
                min: 0,
                max: 100,
                value: widget.shape.topLeftCornerRadius,
                header: Text(AppLocalizations.of(context).topLeft),
                onChangeEnd: (value) => widget.onChanged(
                    widget.shape.copyWith(topLeftCornerRadius: value)),
              ),
              ExactSlider(
                defaultValue: 0,
                min: 0,
                max: 100,
                value: widget.shape.topRightCornerRadius,
                header: Text(AppLocalizations.of(context).topRight),
                onChangeEnd: (value) => widget.onChanged(
                    widget.shape.copyWith(topRightCornerRadius: value)),
              ),
              ExactSlider(
                defaultValue: 0,
                min: 0,
                max: 100,
                value: widget.shape.bottomLeftCornerRadius,
                header: Text(AppLocalizations.of(context).bottomLeft),
                onChangeEnd: (value) => widget.onChanged(
                    widget.shape.copyWith(bottomLeftCornerRadius: value)),
              ),
              ExactSlider(
                defaultValue: 0,
                min: 0,
                max: 100,
                value: widget.shape.bottomRightCornerRadius,
                header: Text(AppLocalizations.of(context).bottomRight),
                onChangeEnd: (value) => widget.onChanged(
                    widget.shape.copyWith(bottomRightCornerRadius: value)),
              ),
            ]),
          ),
        ],
      ),
    ]);
  }
}
