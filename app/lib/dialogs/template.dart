import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/widgets/remote_button.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../api/file_system/file_system.dart';
import '../bloc/document_bloc.dart';
import '../widgets/editable_list_tile.dart';
import 'delete.dart';

class TemplateDialog extends StatefulWidget {
  final NoteData? currentDocument;
  const TemplateDialog({super.key, required this.currentDocument});

  @override
  State<TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<TemplateDialog> {
  late TemplateFileSystem _fileSystem;
  late Future<List<NoteData>>? _templatesFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fileSystem =
        context.read<SettingsCubit>().state.getDefaultTemplateFileSystem();
  }

  void load() {
    _templatesFuture = _fileSystem.createDefault(context).then((value) async {
      var templates = await _fileSystem.getTemplates();
      templates = templates
          .where((element) =>
              element.name?.contains(_searchController.text) ?? true)
          .toList();
      return templates;
    });
  }

  @override
  Widget build(BuildContext context) {
    load();
    return Dialog(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: Column(
              children: [
                Header(
                  title: Text(AppLocalizations.of(context).templates),
                  leading: IconButton(
                    icon: const PhosphorIcon(PhosphorIconsLight.x),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    RemoteButton(
                      currentRemote: _fileSystem.remote?.identifier ?? '',
                      onChanged: (value) {
                        _fileSystem =
                            TemplateFileSystem.fromPlatform(remote: value);
                        load();
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const PhosphorIcon(
                          PhosphorIconsLight.clockCounterClockwise),
                      tooltip: AppLocalizations.of(context).defaultTemplate,
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                AppLocalizations.of(context).defaultTemplate),
                            content:
                                Text(AppLocalizations.of(context).reallyReset),
                            actions: [
                              TextButton(
                                child:
                                    Text(AppLocalizations.of(context).cancel),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              ElevatedButton(
                                child: Text(AppLocalizations.of(context).ok),
                                onPressed: () async {
                                  for (final template
                                      in await _fileSystem.getTemplates()) {
                                    _fileSystem.deleteTemplate(template.name!);
                                  }
                                  if (context.mounted) {
                                    await _fileSystem.createDefault(
                                        this.context,
                                        force: true);
                                  }
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    load();
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ...widget.currentDocument == null
                        ? []
                        : [
                            IconButton(
                              onPressed: () =>
                                  _showCreateDialog(widget.currentDocument!),
                              tooltip: AppLocalizations.of(context).create,
                              icon: const PhosphorIcon(PhosphorIconsLight.plus),
                            )
                          ],
                  ],
                ),
                Flexible(
                  child: FutureBuilder<List<NoteData>>(
                      future: _templatesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        var templates = snapshot.data!;
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                decoration: const InputDecoration(
                                  filled: true,
                                  prefixIcon: PhosphorIcon(
                                      PhosphorIconsLight.magnifyingGlass),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                controller: _searchController,
                                autofocus: true,
                                onChanged: (value) async {
                                  load();
                                  setState(() {});
                                }),
                          ),
                          const Divider(),
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: ListView.builder(
                                      itemCount: templates.length,
                                      itemBuilder: (context, index) {
                                        var template = templates[index];
                                        return _TemplateItem(
                                          template: template,
                                          fileSystem: _fileSystem,
                                          onChanged: () {
                                            load();
                                            setState(() {});
                                          },
                                        );
                                      })))
                        ]);
                      }),
                ),
              ],
            )));
  }

  Future<void> _showCreateDialog(NoteData document) {
    final directoryController = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).createTemplate),
            scrollable: true,
            content: SizedBox(
              width: 500,
              child: Column(
                children: [
                  Text(AppLocalizations.of(context).createTemplateContent),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: directoryController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).directory,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context).cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text(AppLocalizations.of(context).create),
                onPressed: () async {
                  this.context.read<DocumentBloc>().add(TemplateCreated(
                        directory: directoryController.text,
                        remote: _fileSystem.remote?.identifier,
                      ));
                  Navigator.of(context).pop();
                  load();
                  setState(() {});
                },
              ),
            ],
          );
        });
  }
}

class _TemplateItem extends StatelessWidget {
  final NoteData template;
  final TemplateFileSystem fileSystem;
  final VoidCallback onChanged;
  const _TemplateItem({
    required this.template,
    required this.fileSystem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    final settings = settingsCubit.state;
    final isDefault = settings.defaultTemplate == template.name;
    final metadata = template.getMetadata();
    if (metadata == null) {
      return const SizedBox();
    }
    return EditableListTile(
      initialValue: metadata.name,
      subtitle: Text(metadata.description),
      onSaved: (value) {
        if (value == metadata.name) return;
        fileSystem.renameTemplate(metadata.name, value);
        onChanged();
      },
      actions: [
        CheckboxMenuButton(
          value: isDefault,
          child: Text(AppLocalizations.of(context).defaultTemplate),
          onChanged: (value) async {
            final name = metadata.name;
            settingsCubit.changeDefaultTemplate(name);
            Navigator.of(context).pop();
            onChanged();
          },
        ),
        MenuItemButton(
          leadingIcon: const PhosphorIcon(PhosphorIconsLight.trash),
          child: Text(AppLocalizations.of(context).delete),
          onPressed: () async {
            Navigator.of(context).pop();
            final result = await showDialog<bool>(
                context: context, builder: (ctx) => const DeleteDialog());
            if (result != true) return;
            if (context.mounted) {
              await fileSystem.deleteTemplate(metadata.name);
              onChanged();
            }
          },
        ),
      ],
      onTap: () => Navigator.of(context).pop(template),
    );
  }
}
