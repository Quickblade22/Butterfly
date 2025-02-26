import 'package:butterfly/bloc/document_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/transform.dart';
import '../dialogs/svg_export.dart';

class SvgExportIntent extends Intent {
  final BuildContext context;

  const SvgExportIntent(this.context);
}

class SvgExportAction extends Action<SvgExportIntent> {
  SvgExportAction();

  @override
  Future<void> invoke(SvgExportIntent intent) async {
    final bloc = intent.context.read<DocumentBloc>();
    final transform = intent.context.read<TransformCubit>().state;
    final size = MediaQuery.of(intent.context).size;
    var scale = transform.size;
    showDialog<void>(
        builder: (context) => BlocProvider.value(
              value: bloc,
              child: SvgExportDialog(
                width: (size.width / scale).round(),
                height: (size.height / scale).round(),
                x: -transform.position.dx,
                y: -transform.position.dy,
              ),
            ),
        context: intent.context);
  }
}
