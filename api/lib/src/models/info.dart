import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'export.dart';
import 'tool.dart';
import 'view.dart';

part 'info.freezed.dart';
part 'info.g.dart';

@freezed
class DocumentInfo with _$DocumentInfo {
  const factory DocumentInfo({
    @Default([]) List<Tool> tools,
    @Default([]) List<ExportPreset> exportPresets,
    @Default(ViewOption()) ViewOption view,
  }) = _DocumentInfo;

  factory DocumentInfo.fromJson(Map<String, dynamic> json) =>
      _$DocumentInfoFromJson(json);
}

extension DocumentInfoGetter on DocumentInfo {
  ExportPreset? getExportPreset(String name) {
    return exportPresets.firstWhereOrNull((e) => e.name == name);
  }
}
