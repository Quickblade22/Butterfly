import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/cubits/transform.dart';
import 'package:butterfly/helpers/xml_helper.dart';
import 'package:butterfly/renderers/renderer.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xml/xml.dart';

import '../embed/embedding.dart';
import '../handlers/handler.dart';
import '../models/viewport.dart';
import '../selections/selection.dart';
import '../services/asset.dart';
import '../theme.dart';
import '../view_painter.dart';

part 'current_index.freezed.dart';

enum SaveState { saved, saving, unsaved }

@Freezed(equal: false)
class CurrentIndex with _$CurrentIndex {
  const CurrentIndex._();
  const factory CurrentIndex(
    int? index,
    Handler handler,
    CameraViewport cameraViewport,
    SettingsCubit settingsCubit,
    TransformCubit transformCubit, {
    Handler? temporaryHandler,
    @Default([]) List<Renderer> foregrounds,
    Selection? selection,
    @Default(false) bool pinned,
    List<Renderer>? temporaryForegrounds,
    @Default(MouseCursor.defer) MouseCursor cursor,
    MouseCursor? temporaryCursor,
    @Default([]) List<int> pointers,
    int? buttons,
    @Default(AssetLocation(path: '')) AssetLocation location,
    Embedding? embedding,
    @Default(SaveState.unsaved) SaveState saved,
    PreferredSizeWidget? toolbar,
    PreferredSizeWidget? temporaryToolbar,
  }) = _CurrentIndex;

  bool get moveEnabled =>
      settingsCubit.state.inputGestures && pointers.length > 1;

  MouseCursor get currentCursor => temporaryCursor ?? cursor;

  UtilitiesState get utilitiesState => cameraViewport.utilities.element;
}

class CurrentIndexCubit extends Cubit<CurrentIndex> {
  CurrentIndexCubit(SettingsCubit settingsCubit, TransformCubit transformCubit,
      CameraViewport viewport, Embedding? embedding)
      : super(CurrentIndex(
            null, HandHandler(), viewport, settingsCubit, transformCubit,
            embedding: embedding));

  void init(DocumentBloc bloc) {
    changeTool(bloc, state.index ?? 0, null, true, false);
  }

  ThemeData getTheme(bool dark, [ColorScheme? overridden]) =>
      getThemeData(state.settingsCubit.state.design, dark, overridden);

  Handler getHandler({bool disableTemporary = false}) {
    if (disableTemporary) {
      return state.handler;
    } else {
      return state.temporaryHandler ?? state.handler;
    }
  }

  Offset getGridPosition(
      Offset position, DocumentPage page, DocumentInfo info) {
    return state.cameraViewport.utilities
        .getGridPosition(position, page, info, this);
  }

  Handler? changeTool(DocumentBloc bloc, int index,
      [Handler? handler, bool justAdded = false, bool runSelected = true]) {
    final blocState = bloc.state;
    if (blocState is! DocumentLoadSuccess) return null;
    final document = blocState.data;
    final info = blocState.info;
    if (index < 0 || index >= info.tools.length) {
      return null;
    }
    final tool = info.tools[index];
    handler ??= Handler.fromTool(tool);
    if (!runSelected || handler.onSelected(bloc, this, justAdded)) {
      state.handler.dispose(bloc);
      state.temporaryHandler?.dispose(bloc);
      _disposeForegrounds();
      emit(state.copyWith(
        index: index,
        handler: handler,
        cursor: handler.cursor ?? MouseCursor.defer,
        foregrounds: handler.createForegrounds(
            this, document, blocState.page, info, blocState.currentArea),
        toolbar: handler.getToolbar(bloc),
        temporaryForegrounds: null,
        temporaryHandler: null,
        temporaryToolbar: null,
        temporaryCursor: null,
      ));
    }
    return handler;
  }

  Future<void> updateTool(DocumentBloc bloc, Tool tool) async {
    final docState = bloc.state;
    if (docState is! DocumentLoadSuccess) return;
    state.handler.dispose(bloc);
    final handler = Handler.fromTool(tool);
    state.handler.dispose(bloc);
    _disposeForegrounds(false);
    final newForegrounds = handler.createForegrounds(this, docState.data,
        docState.page, docState.info, docState.currentArea);
    for (final r in newForegrounds) {
      await r.setup(docState.data, docState.assetService, docState.page);
    }
    emit(state.copyWith(
      index: state.index,
      handler: handler,
      foregrounds: foregrounds,
      toolbar: handler.getToolbar(bloc),
      cursor: handler.cursor ?? MouseCursor.defer,
    ));
  }

  Future<void> updateTemporaryTool(DocumentBloc bloc, Tool tool) async {
    final docState = bloc.state;
    if (docState is! DocumentLoadSuccess) return;
    state.temporaryHandler?.dispose(bloc);
    final handler = Handler.fromTool(tool);
    _disposeTemporaryForegrounds();
    final temporaryForegrounds = handler.createForegrounds(this, docState.data,
        docState.page, docState.info, docState.currentArea);
    await Future.wait(temporaryForegrounds.map((r) async =>
        await r.setup(docState.data, docState.assetService, docState.page)));
    emit(state.copyWith(
      temporaryHandler: handler,
      temporaryForegrounds: temporaryForegrounds,
      temporaryToolbar: handler.getToolbar(bloc),
      temporaryCursor: handler.cursor,
    ));
  }

  T? fetchHandler<T extends Handler>({bool disableTemporary = false}) {
    final handler = getHandler(disableTemporary: disableTemporary);
    if (handler is T) return handler;
    return null;
  }

  void _disposeForegrounds([bool disposeTemporary = true]) {
    for (final r in state.foregrounds) {
      r.dispose();
    }
    if (disposeTemporary) {
      _disposeTemporaryForegrounds();
    }
  }

  void _disposeTemporaryForegrounds() {
    for (final r in state.temporaryForegrounds ?? []) {
      r.dispose();
    }
  }

  Future<void> refresh(NoteData document, AssetService assetService,
      DocumentPage page, DocumentInfo info,
      [Area? currentArea]) async {
    if (!isClosed) {
      _disposeForegrounds();
      final temporaryForegrounds = state.temporaryHandler
          ?.createForegrounds(this, document, page, info, currentArea);
      if (temporaryForegrounds != null) {
        await Future.wait(temporaryForegrounds
            .map((e) async => await e.setup(document, assetService, page)));
      }
      final foregrounds = state.handler
          .createForegrounds(this, document, page, info, currentArea);
      await Future.wait(foregrounds
          .map((e) async => await e.setup(document, assetService, page)));
      emit(state.copyWith(
        temporaryForegrounds: temporaryForegrounds,
        foregrounds: foregrounds,
        cursor: state.handler.cursor ?? MouseCursor.defer,
        temporaryCursor: state.temporaryHandler?.cursor,
      ));
    }
  }

  Future<void> refreshToolbar(DocumentBloc bloc) async {
    if (!isClosed) {
      final toolbar = state.handler.getToolbar(bloc);
      final temporaryToolbar = state.temporaryHandler?.getToolbar(bloc);
      emit(state.copyWith(
        toolbar: toolbar,
        temporaryToolbar: temporaryToolbar,
      ));
    }
  }

  Tool? getTool(DocumentInfo info) {
    var index = state.index;
    if (index == null) {
      return null;
    }
    if (info.tools.isEmpty || index < 0 || index >= info.tools.length) {
      return null;
    }
    return info.tools[index];
  }

  T? fetchTool<T extends Tool>(DocumentInfo info) {
    final tool = getTool(info);
    if (tool is T) return tool;
    return null;
  }

  void reset(DocumentBloc bloc) {
    for (final r in renderers) {
      r.dispose();
    }
    state.handler.dispose(bloc);
    state.temporaryHandler?.dispose(bloc);
    _disposeForegrounds();
    emit(state.copyWith(
      index: null,
      handler: HandHandler(),
      cursor: MouseCursor.defer,
      foregrounds: [],
      temporaryHandler: null,
      temporaryForegrounds: null,
      temporaryCursor: null,
      cameraViewport: CameraViewport.unbaked(UtilitiesRenderer()),
    ));
  }

  void changeIndex(int i) {
    emit(state.copyWith(index: i));
  }

  void addPointer(int pointer) {
    emit(state.copyWith(pointers: state.pointers.toList()..add(pointer)));
  }

  void removePointer(int pointer) {
    emit(state.copyWith(pointers: state.pointers.toList()..remove(pointer)));
  }

  Future<Handler?> changeTemporaryHandlerIndex(
      DocumentBloc bloc, int index) async {
    final blocState = bloc.state;
    if (blocState is! DocumentLoadSuccess) return null;
    if (index < 0 || index >= blocState.info.tools.length) {
      return null;
    }
    final tool = blocState.info.tools[index];
    return changeTemporaryHandler(bloc, tool);
  }

  Future<Handler?> changeTemporaryHandler(DocumentBloc bloc, Tool tool) async {
    final handler = Handler.fromTool(tool);
    final blocState = bloc.state;
    if (blocState is! DocumentLoadSuccess) return null;
    final document = blocState.data;
    final page = blocState.page;
    final currentArea = blocState.currentArea;
    state.temporaryHandler?.dispose(bloc);
    if (handler.onSelected(bloc, this, false)) {
      _disposeTemporaryForegrounds();
      final temporaryForegrounds = handler.createForegrounds(
          this, document, page, blocState.info, currentArea);
      await Future.wait(temporaryForegrounds.map(
          (e) async => await e.setup(document, blocState.assetService, page)));
      emit(state.copyWith(
        temporaryHandler: handler,
        temporaryForegrounds: temporaryForegrounds,
        temporaryToolbar: handler.getToolbar(bloc),
        temporaryCursor: handler.cursor,
      ));
    }
    return handler;
  }

  List<Renderer> get foregrounds =>
      state.temporaryForegrounds ?? state.foregrounds;

  void resetTemporaryHandler(DocumentBloc bloc) {
    if (state.temporaryHandler == null) {
      return;
    }
    state.temporaryHandler?.dispose(bloc);
    _disposeTemporaryForegrounds();
    emit(state.copyWith(
      temporaryHandler: null,
      temporaryForegrounds: null,
      temporaryToolbar: null,
      temporaryCursor: null,
    ));
  }

  List<Renderer<PadElement>> get renderers =>
      List.from(state.cameraViewport.bakedElements)
        ..addAll(state.cameraViewport.unbakedElements);

  Renderer? getRenderer(PadElement element) =>
      renderers.firstWhereOrNull((renderer) => renderer.element == element);

  Future<void> bake(NoteData document, DocumentPage page, DocumentInfo info,
      {Size? viewportSize, double? pixelRatio, bool reset = false}) async {
    final cameraViewport = state.cameraViewport;
    final size = viewportSize ?? cameraViewport.toSize();
    final ratio = pixelRatio ?? cameraViewport.pixelRatio;
    if (size.height <= 0 || size.width <= 0) {
      return;
    }
    final transform = state.transformCubit.state;
    final rect = Rect.fromLTWH(-transform.position.dx, -transform.position.dy,
        size.width / transform.size, size.height / transform.size);
    var renderers =
        List<Renderer<PadElement>>.from(cameraViewport.unbakedElements);
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final last = state.cameraViewport;
    reset = reset ||
        last.width != size.width.ceil() ||
        last.height != size.height.ceil() ||
        last.x != transform.position.dx ||
        last.y != transform.position.dy ||
        last.scale != transform.size;
    if (renderers.isEmpty && !reset) return;
    List<Renderer<PadElement>> visibleElements;
    if (reset) {
      renderers = List<Renderer<PadElement>>.from(this.renderers);
      visibleElements = renderers
          .where((renderer) => renderer.expandedRect?.overlaps(rect) ?? true)
          .toList();
    } else {
      visibleElements = List.from(cameraViewport.visibleElements)
        ..addAll(renderers);
    }
    canvas.scale(ratio);

    // Wait one frame
    await Future.delayed(const Duration(milliseconds: 1));

    ViewPainter(
      document,
      page,
      info,
      transform: state.transformCubit.state,
      cameraViewport: reset
          ? cameraViewport.unbake(
              unbakedElements: visibleElements,
              visibleElements: visibleElements)
          : last,
      renderBackground: false,
      renderBaked: !reset,
    ).paint(canvas, size);

    var picture = recorder.endRecording();

    var newImage = await picture.toImage(
        (size.width * ratio).ceil(), (size.height * ratio).ceil());

    var currentRenderers = state.cameraViewport.unbakedElements;
    if (reset) {
      currentRenderers = this.renderers;
    } else {
      renderers.addAll(state.cameraViewport.bakedElements);
    }
    currentRenderers = currentRenderers
        .whereNot((element) => renderers.contains(element))
        .toList();
    visibleElements.addAll(currentRenderers);
    emit(state.copyWith(
        cameraViewport: cameraViewport.bake(
            height: size.height.ceil(),
            width: size.width.ceil(),
            pixelRatio: ratio,
            scale: state.transformCubit.state.size,
            x: state.transformCubit.state.position.dx,
            y: state.transformCubit.state.position.dy,
            image: newImage,
            bakedElements: renderers,
            unbakedElements: currentRenderers,
            visibleElements: visibleElements)));
  }

  Future<ByteData?> render(
      NoteData document, DocumentPage page, DocumentInfo info,
      {required double width,
      required double height,
      double x = 0,
      double y = 0,
      double scale = 1,
      double quality = 1,
      bool renderBackground = true}) async {
    final realWidth = (width * quality).ceil();
    final realHeight = (height * quality).ceil();
    final realZoom = scale * quality;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = ViewPainter(document, page, info,
        renderBackground: renderBackground,
        cameraViewport: state.cameraViewport.unbake(unbakedElements: renderers),
        transform:
            CameraTransform(-Offset(x.toDouble(), y.toDouble()), realZoom));
    painter.paint(canvas, Size(realWidth.toDouble(), realHeight.toDouble()));
    final picture = recorder.endRecording();
    final image = await picture.toImage(realWidth, realHeight);
    return await image.toByteData(format: ui.ImageByteFormat.png);
  }

  XmlDocument renderSVG(DocumentPage page,
      {required int width,
      required int height,
      double x = 0,
      double y = 0,
      bool renderBackground = true}) {
    final xml = XmlDocument();
    xml.createElement('svg', attributes: {
      'xmlns': 'http://www.w3.org/2000/svg',
      'xmlns:xlink': 'http://www.w3.org/1999/xlink',
      'version': '1.1',
      'width': '${width}px',
      'height': '${height}px',
      'viewBox': '$x $y $width $height',
    });

    final rect = Rect.fromLTWH(x, y, width.toDouble(), height.toDouble());
    if (renderBackground) {
      state.cameraViewport.backgrounds.map((e) => e.buildSvg(xml, page, rect));
    }
    for (var e in renderers) {
      e.buildSvg(xml, page, rect);
    }
    return xml;
  }

  void unbake(
      {List<Renderer<Background>>? backgrounds,
      UtilitiesRenderer? tool,
      List<Renderer<PadElement>>? unbakedElements}) {
    emit(state.copyWith(
        cameraViewport: state.cameraViewport.unbake(
            unbakedElements: unbakedElements,
            utilities: tool,
            backgrounds: backgrounds)));
  }

  Future<void> loadElements(
      NoteData document, AssetService assetService, DocumentPage page) async {
    for (var e in state.cameraViewport.unbakedElements) {
      e.dispose();
    }
    for (var e in state.cameraViewport.bakedElements) {
      e.dispose();
    }
    final renderers =
        page.content.map((e) => Renderer.fromInstance(e)).toList();
    await Future.wait(renderers
        .map((e) async => await e.setup(document, assetService, page)));
    emit(state.copyWith(
        cameraViewport: state.cameraViewport.withUnbaked(renderers)));
  }

  void withUnbaked(List<Renderer<PadElement>> unbakedElements) {
    emit(state.copyWith(
        cameraViewport: state.cameraViewport.withUnbaked(unbakedElements)));
  }

  void setSaveState({AssetLocation? location, SaveState? saved}) {
    emit(state.copyWith(
        location: location ?? state.location, saved: saved ?? state.saved));
  }

  Future<pw.Document> renderPDF(
    NoteData document,
    DocumentInfo info, {
    required List<AreaPreset> areas,
    bool renderBackground = true,
  }) async {
    final pdf = pw.Document();
    for (final preset in areas) {
      final areaName = preset.name;
      final quality = preset.quality;
      final page = document.getPage(preset.page);
      final area = preset.area ?? page?.getAreaByName(areaName);
      if (area == null || page == null) {
        continue;
      }
      final pageFormat =
          PdfPageFormat(area.width * quality, area.height * quality);
      final image = await render(document, page, info,
          width: area.width,
          height: area.height,
          x: area.position.x,
          y: area.position.y,
          quality: quality,
          renderBackground: renderBackground);
      if (image == null) continue;
      pdf.addPage(pw.Page(
          pageFormat: pageFormat,
          build: (context) {
            return pw.Image(pw.MemoryImage(image.buffer.asUint8List()));
          }));
    }
    return pdf;
  }

  void updateIndex(DocumentBloc bloc) {
    final docState = bloc.state;
    if (docState is! DocumentLoadSuccess) return;
    final info = docState.info;
    final index = info.tools.indexOf(state.handler.data);
    if (index < 0) {
      changeTool(bloc, state.index ?? 0, null, true, false);
    }
    if (index == state.index) {
      return;
    }
    changeIndex(index);
    final selection = state.selection;
    if (selection?.selected.contains(state.handler.data) ?? false) {
      resetSelection();
    }
  }

  void insertSelection(dynamic selected, [bool toggle = true]) {
    final selection = state.selection;
    if (selection == null) {
      emit(state.copyWith(selection: Selection.from(selected)));
      return;
    }
    Selection? next;
    if (selection.selected.contains(selected) && toggle) {
      if (selection.selected.length != 1) {
        next = selection.remove(selected);
      }
    } else {
      next = selection.insert(selected);
    }
    emit(state.copyWith(selection: next));
  }

  void changeSelection(dynamic selected, [bool toggle = true]) {
    Selection? selection;
    if (selected is Selection?) {
      selection = selected;
    } else if (!toggle ||
        !(state.selection?.selected.contains(selected) ?? false)) {
      selection = Selection.from(selected);
    }
    emit(state.copyWith(selection: selection));
  }

  void removeSelection(List selected) {
    Selection? selection = state.selection;
    if (selection == null) {
      return;
    }
    for (final s in selected) {
      selection = selection?.remove(s);
    }
    emit(state.copyWith(selection: selection));
  }

  void resetSelection() {
    emit(state.copyWith(selection: null));
  }

  void setButtons(int buttons) {
    emit(state.copyWith(buttons: buttons));
  }

  void removeButtons() {
    emit(state.copyWith(buttons: null));
  }

  void resetInput(DocumentBloc bloc) {
    state.handler.resetInput(bloc);
    emit(state.copyWith(buttons: null, pointers: []));
  }

  void changeTemporaryHandlerMove() {
    emit(
        state.copyWith(temporaryHandler: HandHandler(), temporaryCursor: null));
  }

  void updateUtilities(UtilitiesState utilitesState) {
    final renderer = UtilitiesRenderer(utilitesState);
    var newSelection =
        state.selection?.remove(state.cameraViewport.utilities.element);
    if (newSelection == null && state.selection != null) {
      newSelection = Selection.from(utilitesState);
    } else if (newSelection != state.selection) {
      newSelection = newSelection?.insert(renderer);
    }
    emit(state.copyWith(
        cameraViewport: state.cameraViewport.withUtilities(renderer),
        selection: newSelection));
  }

  void togglePin() => emit(state.copyWith(pinned: !state.pinned));

  void move(Offset delta, [bool force = false]) {
    final utilitiesState = state.utilitiesState;
    if (utilitiesState.lockHorizontal && !force) {
      delta = Offset(0, delta.dy);
    }
    if (utilitiesState.lockVertical && !force) {
      delta = Offset(delta.dx, 0);
    }
    if (delta.dx == 0 && delta.dy == 0) {
      return;
    }
    state.transformCubit.move(delta);
  }

  void zoom(double delta, [Offset cursor = Offset.zero, bool force = false]) {
    final utilitiesState = state.utilitiesState;
    if (utilitiesState.lockZoom && !force) {
      delta = 1;
    }
    if (delta == 1) {
      return;
    }
    state.transformCubit.zoom(delta, cursor);
  }
}
