// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DocumentInfo _$DocumentInfoFromJson(Map<String, dynamic> json) {
  return _DocumentInfo.fromJson(json);
}

/// @nodoc
mixin _$DocumentInfo {
  List<Tool> get tools => throw _privateConstructorUsedError;
  List<ExportPreset> get exportPresets => throw _privateConstructorUsedError;
  ViewOption get view => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentInfoCopyWith<DocumentInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentInfoCopyWith<$Res> {
  factory $DocumentInfoCopyWith(
          DocumentInfo value, $Res Function(DocumentInfo) then) =
      _$DocumentInfoCopyWithImpl<$Res, DocumentInfo>;
  @useResult
  $Res call(
      {List<Tool> tools, List<ExportPreset> exportPresets, ViewOption view});

  $ViewOptionCopyWith<$Res> get view;
}

/// @nodoc
class _$DocumentInfoCopyWithImpl<$Res, $Val extends DocumentInfo>
    implements $DocumentInfoCopyWith<$Res> {
  _$DocumentInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tools = null,
    Object? exportPresets = null,
    Object? view = null,
  }) {
    return _then(_value.copyWith(
      tools: null == tools
          ? _value.tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<Tool>,
      exportPresets: null == exportPresets
          ? _value.exportPresets
          : exportPresets // ignore: cast_nullable_to_non_nullable
              as List<ExportPreset>,
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as ViewOption,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ViewOptionCopyWith<$Res> get view {
    return $ViewOptionCopyWith<$Res>(_value.view, (value) {
      return _then(_value.copyWith(view: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DocumentInfoCopyWith<$Res>
    implements $DocumentInfoCopyWith<$Res> {
  factory _$$_DocumentInfoCopyWith(
          _$_DocumentInfo value, $Res Function(_$_DocumentInfo) then) =
      __$$_DocumentInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Tool> tools, List<ExportPreset> exportPresets, ViewOption view});

  @override
  $ViewOptionCopyWith<$Res> get view;
}

/// @nodoc
class __$$_DocumentInfoCopyWithImpl<$Res>
    extends _$DocumentInfoCopyWithImpl<$Res, _$_DocumentInfo>
    implements _$$_DocumentInfoCopyWith<$Res> {
  __$$_DocumentInfoCopyWithImpl(
      _$_DocumentInfo _value, $Res Function(_$_DocumentInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tools = null,
    Object? exportPresets = null,
    Object? view = null,
  }) {
    return _then(_$_DocumentInfo(
      tools: null == tools
          ? _value._tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<Tool>,
      exportPresets: null == exportPresets
          ? _value._exportPresets
          : exportPresets // ignore: cast_nullable_to_non_nullable
              as List<ExportPreset>,
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as ViewOption,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DocumentInfo implements _DocumentInfo {
  const _$_DocumentInfo(
      {final List<Tool> tools = const [],
      final List<ExportPreset> exportPresets = const [],
      this.view = const ViewOption()})
      : _tools = tools,
        _exportPresets = exportPresets;

  factory _$_DocumentInfo.fromJson(Map<String, dynamic> json) =>
      _$$_DocumentInfoFromJson(json);

  final List<Tool> _tools;
  @override
  @JsonKey()
  List<Tool> get tools {
    if (_tools is EqualUnmodifiableListView) return _tools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tools);
  }

  final List<ExportPreset> _exportPresets;
  @override
  @JsonKey()
  List<ExportPreset> get exportPresets {
    if (_exportPresets is EqualUnmodifiableListView) return _exportPresets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exportPresets);
  }

  @override
  @JsonKey()
  final ViewOption view;

  @override
  String toString() {
    return 'DocumentInfo(tools: $tools, exportPresets: $exportPresets, view: $view)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DocumentInfo &&
            const DeepCollectionEquality().equals(other._tools, _tools) &&
            const DeepCollectionEquality()
                .equals(other._exportPresets, _exportPresets) &&
            (identical(other.view, view) || other.view == view));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tools),
      const DeepCollectionEquality().hash(_exportPresets),
      view);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DocumentInfoCopyWith<_$_DocumentInfo> get copyWith =>
      __$$_DocumentInfoCopyWithImpl<_$_DocumentInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DocumentInfoToJson(
      this,
    );
  }
}

abstract class _DocumentInfo implements DocumentInfo {
  const factory _DocumentInfo(
      {final List<Tool> tools,
      final List<ExportPreset> exportPresets,
      final ViewOption view}) = _$_DocumentInfo;

  factory _DocumentInfo.fromJson(Map<String, dynamic> json) =
      _$_DocumentInfo.fromJson;

  @override
  List<Tool> get tools;
  @override
  List<ExportPreset> get exportPresets;
  @override
  ViewOption get view;
  @override
  @JsonKey(ignore: true)
  _$$_DocumentInfoCopyWith<_$_DocumentInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
