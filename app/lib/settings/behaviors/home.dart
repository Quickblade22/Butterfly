import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/visualizer/sync.dart';
import 'package:butterfly/widgets/window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BehaviorsSettingsPage extends StatelessWidget {
  final bool inView;

  const BehaviorsSettingsPage({super.key, this.inView = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inView ? Colors.transparent : null,
        appBar: WindowTitleBar(
          title: Text(AppLocalizations.of(context).behaviors),
          backgroundColor: inView ? Colors.transparent : null,
          inView: inView,
        ),
        body: BlocBuilder<SettingsCubit, ButterflySettings>(
            builder: (context, state) {
          return ListView(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ExactSlider(
                          header: Text(AppLocalizations.of(context).imageScale),
                          value: state.imageScale * 100,
                          min: 0,
                          max: 100,
                          defaultValue: 50,
                          fractionDigits: 0,
                          onChangeEnd: (value) => context
                              .read<SettingsCubit>()
                              .changeImageScale(value / 100),
                        )
                      ]),
                ),
              ),
              if (!kIsWeb)
                Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(AppLocalizations.of(context).connection,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 16),
                            ListTile(
                              title:
                                  Text(AppLocalizations.of(context).syncMode),
                              leading: PhosphorIcon(state.syncMode.getIcon()),
                              subtitle: Text(
                                  state.syncMode.getLocalizedName(context)),
                              onTap: () => _openSyncModeModal(context),
                            ),
                          ]),
                    )),
              Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(AppLocalizations.of(context).inputs,
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 16),
                          ListTile(
                            leading:
                                const PhosphorIcon(PhosphorIconsLight.mouse),
                            title: Text(AppLocalizations.of(context).mouse),
                            onTap: () =>
                                context.push('/settings/behaviors/mouse'),
                          ),
                          ListTile(
                            leading:
                                const PhosphorIcon(PhosphorIconsLight.hand),
                            title: Text(AppLocalizations.of(context).touch),
                            onTap: () =>
                                context.push('/settings/behaviors/touch'),
                          ),
                          ListTile(
                            leading:
                                const PhosphorIcon(PhosphorIconsLight.keyboard),
                            title: Text(AppLocalizations.of(context).keyboard),
                            onTap: () =>
                                context.push('/settings/behaviors/keyboard'),
                          ),
                          ListTile(
                            leading: const PhosphorIcon(PhosphorIconsLight.pen),
                            title: Text(AppLocalizations.of(context).pen),
                            onTap: () =>
                                context.push('/settings/behaviors/pen'),
                          ),
                        ]),
                  )),
            ],
          );
        }));
  }

  Future<void> _openSyncModeModal(BuildContext context) => showLeapBottomSheet(
      context: context,
      title: AppLocalizations.of(context).syncMode,
      childrenBuilder: (ctx) {
        final settingsCubit = context.read<SettingsCubit>();
        void changeSyncMode(SyncMode syncMode) {
          settingsCubit.changeSyncMode(syncMode);
          Navigator.of(context).pop();
        }

        return [
          ...SyncMode.values.map((syncMode) {
            return ListTile(
              title: Text(syncMode.getLocalizedName(context)),
              leading: PhosphorIcon(syncMode.getIcon()),
              selected: syncMode == settingsCubit.state.syncMode,
              onTap: () => changeSyncMode(syncMode),
            );
          }),
          const SizedBox(height: 32),
        ];
      });
}
