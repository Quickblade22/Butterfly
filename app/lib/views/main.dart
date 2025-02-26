import 'package:butterfly/api/file_system/file_system.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/current_index.dart';
import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/cubits/transform.dart';
import 'package:butterfly/embed/embedding.dart';
import 'package:butterfly/models/defaults.dart';
import 'package:butterfly/renderers/renderer.dart';
import 'package:butterfly/services/import.dart';
import 'package:butterfly/views/app_bar.dart';
import 'package:butterfly/views/navigator.dart';
import 'package:butterfly/views/toolbar.dart';
import 'package:butterfly/views/edit.dart';
import 'package:butterfly/views/error.dart';
import 'package:butterfly/views/property.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions/areas.dart';
import '../actions/background.dart';
import '../actions/change_tool.dart';
import '../actions/change_path.dart';
import '../actions/color_palette.dart';
import '../actions/exit.dart';
import '../actions/export.dart';
import '../actions/image_export.dart';
import '../actions/new.dart';
import '../actions/next.dart';
import '../actions/packs.dart';
import '../actions/paste.dart';
import '../actions/pdf_export.dart';
import '../actions/previous.dart';
import '../actions/redo.dart';
import '../actions/save.dart';
import '../actions/select.dart';
import '../actions/settings.dart';
import '../actions/svg_export.dart';
import '../actions/undo.dart';
import '../main.dart';
import '../models/viewport.dart';
import '../services/asset.dart';
import 'changes.dart';
import 'view.dart';
import 'zoom.dart';

class ProjectPage extends StatefulWidget {
  final AssetLocation? location;
  final Embedding? embedding;
  final String type;
  final Object? data;

  const ProjectPage(
      {super.key, this.location, this.embedding, this.type = '', this.data});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  // ignore: closeSinks
  DocumentBloc? _bloc;
  TransformCubit? _transformCubit;
  CurrentIndexCubit? _currentIndexCubit;
  RemoteStorage? _remote;
  ImportService? _importService;
  final GlobalKey _viewportKey = GlobalKey();
  final _actions = <Type, Action<Intent>>{
    UndoIntent: UndoAction(),
    RedoIntent: RedoAction(),
    NewIntent: NewAction(),
    SvgExportIntent: SvgExportAction(),
    ImageExportIntent: ImageExportAction(),
    PdfExportIntent: PdfExportAction(),
    ExportIntent: ExportAction(),
    SettingsIntent: SettingsAction(),
    AreasIntent: AreasAction(),
    ColorPaletteIntent: ColorPaletteAction(),
    BackgroundIntent: BackgroundAction(),
    ChangePathIntent: ChangePathAction(),
    SaveIntent: SaveAction(),
    ChangeToolIntent: ChangeToolAction(),
    PacksIntent: PacksAction(),
    ExitIntent: ExitAction(),
    NextIntent: NextAction(),
    PreviousIntent: PreviousAction(),
    PasteIntent: PasteAction(),
    SelectAllIntent: SelectAllAction(),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(ProjectPage oldWidget) {
    if (oldWidget.location != widget.location) {
      _bloc?.close();
      _bloc = null;
      _load();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _load() async {
    final settingsCubit = context.read<SettingsCubit>();
    final embedding = widget.embedding;
    if (embedding != null) {
      final document = DocumentDefaults.createDocument();
      var language = embedding.language;
      if (language == 'system') {
        language = '';
      }
      if (language != 'user') {
        settingsCubit.changeLocaleTemporarily(language);
      }
      setState(() {
        _transformCubit = TransformCubit();
        _currentIndexCubit = CurrentIndexCubit(settingsCubit, _transformCubit!,
            CameraViewport.unbaked(UtilitiesRenderer()), embedding);
        _bloc = DocumentBloc(
          _currentIndexCubit!,
          settingsCubit,
          document,
          widget.location ?? const AssetLocation(path: ''),
          [],
        );
        _bloc?.load();
        embedding.handler.register(context, _bloc!);
      });
      return;
    }
    try {
      final globalImportService = ImportService(context);
      var location = widget.location;
      _remote = location != null
          ? settingsCubit.state.getRemote(location.remote)
          : settingsCubit.state.getDefaultRemote();
      final fileSystem = DocumentFileSystem.fromPlatform(remote: _remote);
      final prefs = await SharedPreferences.getInstance();
      final fileType =
          AssetFileTypeHelper.fromFileExtension(location?.fileExtension)?.name;
      NoteData? document;
      if (widget.data != null) {
        document ??= await globalImportService.load(
            type: widget.type.isEmpty ? (fileType ?? widget.type) : widget.type,
            data: widget.data);
      }
      final name = (location?.absolute ?? false) ? location!.fileName : '';
      NoteData? defaultDocument;
      if (document == null && prefs.containsKey('default_template')) {
        var template = await TemplateFileSystem.fromPlatform(remote: _remote)
            .getTemplate(prefs.getString('default_template')!);
        if (template != null && mounted) {
          defaultDocument = template.createDocument(
            name: name,
            createdAt: DateTime.now(),
          );
        }
      }
      defaultDocument ??= DocumentDefaults.createDocument(
        name: name,
      );
      if (location != null && location.path.isNotEmpty && document == null) {
        if (!location.absolute) {
          final asset = await fileSystem.getAsset(location.path);
          if (!mounted) return;
          if (asset?.fileType == AssetFileType.note) {
            document = await checkFileChanges(context, asset);
          }
        } else {
          final data = await fileSystem.loadAbsolute(location.path);
          if (data != null) {
            document = await globalImportService.load(
                document: defaultDocument,
                type: widget.type.isEmpty
                    ? (fileType ?? widget.type)
                    : widget.type,
                data: data);
          }
        }
      }
      if (!mounted) return;
      var documentOpened = document != null;
      if (!documentOpened && !(location?.absolute ?? false)) {
        location = null;
      }
      if (!mounted) {
        return;
      }
      document ??= defaultDocument;
      final pageName = document.getPages().firstOrNull ?? 'default';
      final page = document.getPage(pageName) ?? DocumentDefaults.createPage();
      final renderers =
          page.content.map((e) => Renderer.fromInstance(e)).toList();
      final assetService = AssetService(document);
      await Future.wait(renderers
          .map((e) async => await e.setup(document!, assetService, page)));
      final backgrounds = page.backgrounds.map(Renderer.fromInstance).toList();
      await Future.wait(
          backgrounds.map((e) async => e.setup(document!, assetService, page)));
      location ??= AssetLocation(
          path: widget.location?.path ?? '', remote: _remote?.identifier ?? '');
      setState(() {
        _transformCubit = TransformCubit();
        _currentIndexCubit = CurrentIndexCubit(settingsCubit, _transformCubit!,
            CameraViewport.unbaked(UtilitiesRenderer(), backgrounds), null);
        _bloc = DocumentBloc(_currentIndexCubit!, settingsCubit, document!,
            location!, renderers, assetService, page, pageName);
        _importService = ImportService(context, _bloc, _currentIndexCubit);
      });
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        _transformCubit = TransformCubit();
        _currentIndexCubit = CurrentIndexCubit(settingsCubit, _transformCubit!,
            CameraViewport.unbaked(UtilitiesRenderer()), null);
        _bloc = DocumentBloc.error(settingsCubit, e.toString(), stackTrace);
      });
    }
    WidgetsBinding.instance.scheduleFrameCallback((_) async {
      _bloc?.load();
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.embedding?.handler.unregister();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      return const Material(child: Center(child: CircularProgressIndicator()));
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bloc!),
        BlocProvider.value(value: _transformCubit!),
        BlocProvider.value(value: _currentIndexCubit!),
      ],
      child: BlocBuilder<DocumentBloc, DocumentState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (context, state) {
          if (state is DocumentLoadFailure) {
            return ErrorPage(
                message: state.message, stackTrace: state.stackTrace);
          }
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<DocumentFileSystem>.value(
                  value: DocumentFileSystem.fromPlatform(remote: _remote)),
              RepositoryProvider<TemplateFileSystem>.value(
                  value: TemplateFileSystem.fromPlatform(remote: _remote)),
              RepositoryProvider<PackFileSystem>.value(
                  value: PackFileSystem.fromPlatform(remote: _remote)),
              RepositoryProvider.value(value: _importService!)
            ],
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: BlocBuilder<SettingsCubit, ButterflySettings>(
                  buildWhen: (previous, current) =>
                      previous.fullScreen != current.fullScreen,
                  builder: (context, settings) {
                    return Actions(
                      actions: _actions,
                      child: Shortcuts(
                        shortcuts: {
                          LogicalKeySet(LogicalKeyboardKey.control,
                              LogicalKeyboardKey.keyZ): UndoIntent(context),
                          LogicalKeySet(LogicalKeyboardKey.control,
                              LogicalKeyboardKey.keyY): RedoIntent(context),
                          LogicalKeySet(LogicalKeyboardKey.control,
                                  LogicalKeyboardKey.keyN):
                              NewIntent(context, fromTemplate: false),
                          LogicalKeySet(
                                  LogicalKeyboardKey.control,
                                  LogicalKeyboardKey.shift,
                                  LogicalKeyboardKey.keyN):
                              NewIntent(context, fromTemplate: true),
                          LogicalKeySet(LogicalKeyboardKey.control,
                                  LogicalKeyboardKey.keyP):
                              ColorPaletteIntent(context),
                          LogicalKeySet(LogicalKeyboardKey.control,
                                  LogicalKeyboardKey.keyB):
                              BackgroundIntent(context),
                          LogicalKeySet(
                              LogicalKeyboardKey.control,
                              LogicalKeyboardKey.shift,
                              LogicalKeyboardKey.keyA): AreasIntent(context),
                          LogicalKeySet(LogicalKeyboardKey.escape):
                              ExitIntent(context),
                          LogicalKeySet(LogicalKeyboardKey.arrowRight):
                              NextIntent(context),
                          LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                              PreviousIntent(context),
                          LogicalKeySet(LogicalKeyboardKey.control,
                                  LogicalKeyboardKey.keyA):
                              SelectAllIntent(context),
                          if (widget.embedding == null) ...{
                            LogicalKeySet(LogicalKeyboardKey.control,
                                LogicalKeyboardKey.keyE): ExportIntent(context),
                            LogicalKeySet(
                                    LogicalKeyboardKey.control,
                                    LogicalKeyboardKey.shift,
                                    LogicalKeyboardKey.keyE):
                                ImageExportIntent(context),
                            LogicalKeySet(
                                    LogicalKeyboardKey.control,
                                    LogicalKeyboardKey.alt,
                                    LogicalKeyboardKey.shift,
                                    LogicalKeyboardKey.keyE):
                                PdfExportIntent(context),
                            LogicalKeySet(
                                    LogicalKeyboardKey.control,
                                    LogicalKeyboardKey.alt,
                                    LogicalKeyboardKey.keyE):
                                SvgExportIntent(context),
                            LogicalKeySet(
                                    LogicalKeyboardKey.control,
                                    LogicalKeyboardKey.alt,
                                    LogicalKeyboardKey.keyS):
                                SettingsIntent(context),
                            LogicalKeySet(LogicalKeyboardKey.alt,
                                    LogicalKeyboardKey.keyS):
                                ChangePathIntent(context),
                            LogicalKeySet(LogicalKeyboardKey.control,
                                LogicalKeyboardKey.keyS): SaveIntent(context),
                            LogicalKeySet(
                                LogicalKeyboardKey.control,
                                LogicalKeyboardKey.alt,
                                LogicalKeyboardKey.keyP): PacksIntent(context),
                            ...[
                              LogicalKeyboardKey.digit1,
                              LogicalKeyboardKey.digit2,
                              LogicalKeyboardKey.digit3,
                              LogicalKeyboardKey.digit4,
                              LogicalKeyboardKey.digit5,
                              LogicalKeyboardKey.digit6,
                              LogicalKeyboardKey.digit7,
                              LogicalKeyboardKey.digit8,
                              LogicalKeyboardKey.digit9,
                              LogicalKeyboardKey.digit0
                            ].asMap().map((k, v) => MapEntry(
                                LogicalKeySet(LogicalKeyboardKey.control, v),
                                ChangeToolIntent(context, k))),
                          },
                        },
                        child: SafeArea(
                          child: ClipRect(
                            child: Focus(
                              autofocus: true,
                              skipTraversal: true,
                              onFocusChange: (_) => false,
                              child: Scaffold(
                                  appBar: state is DocumentPresentationState ||
                                          settings.fullScreen
                                      ? null
                                      : PadAppBar(
                                          viewportKey: _viewportKey,
                                        ),
                                  drawer: state is DocumentLoadSuccess
                                      ? const DocumentNavigator(asDrawer: true)
                                      : null,
                                  body: Actions(
                                    actions: _actions,
                                    child: const _MainBody(),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  const _MainBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
        buildWhen: (previous, current) =>
            (previous is DocumentLoadSuccess &&
                current is! DocumentLoadSuccess) ||
            (previous is! DocumentLoadSuccess &&
                current is DocumentLoadSuccess),
        builder: (context, state) =>
            BlocBuilder<SettingsCubit, ButterflySettings>(
                buildWhen: (previous, current) =>
                    previous.toolbarPosition != current.toolbarPosition ||
                    previous.fullScreen != current.fullScreen ||
                    previous.navigationRail != current.navigationRail,
                builder: (context, settings) {
                  final pos = settings.toolbarPosition;
                  return LayoutBuilder(builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < kMobileWidth;
                    final isLarge = constraints.maxWidth > kLargeWidth;
                    final toolbar = EditToolbar(
                      isMobile: false,
                      centered: true,
                      direction: pos == ToolbarPosition.bottom ||
                              pos == ToolbarPosition.top ||
                              isMobile
                          ? Axis.horizontal
                          : Axis.vertical,
                    );
                    return Stack(
                      children: [
                        const MainViewViewport(),
                        BlocBuilder<CurrentIndexCubit, CurrentIndex>(
                            builder: (context, state) {
                          return Listener(
                            behavior: state.pinned || state.selection == null
                                ? HitTestBehavior.translucent
                                : HitTestBehavior.opaque,
                            onPointerUp: (details) {
                              if (state.pinned) return;
                              context
                                  .read<CurrentIndexCubit>()
                                  .resetSelection();
                            },
                          );
                        }),
                        Row(
                          children: [
                            if (isLarge &&
                                settings.navigationRail &&
                                !settings.fullScreen &&
                                state is DocumentLoadSuccess)
                              const NavigatorView(),
                            if (pos == ToolbarPosition.left && !isMobile)
                              toolbar,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (settings.fullScreen &&
                                      pos == ToolbarPosition.top &&
                                      !isMobile)
                                    toolbar,
                                  if (pos == ToolbarPosition.top || isMobile)
                                    const ToolbarView(),
                                  const Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: PropertyView(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        width: isMobile ? 100 : 400,
                                        child: ZoomView(isMobile: isMobile),
                                      ),
                                    ),
                                  ),
                                  if (pos != ToolbarPosition.top && !isMobile)
                                    const ToolbarView(),
                                  if (isMobile || pos == ToolbarPosition.bottom)
                                    toolbar,
                                ],
                              ),
                            ),
                            if (pos == ToolbarPosition.right) toolbar,
                          ],
                        ),
                      ],
                    );
                  });
                }));
  }
}
