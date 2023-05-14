// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'viewed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ViewedProdModel {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ViewedProdModelCopyWith<ViewedProdModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViewedProdModelCopyWith<$Res> {
  factory $ViewedProdModelCopyWith(
          ViewedProdModel value, $Res Function(ViewedProdModel) then) =
      _$ViewedProdModelCopyWithImpl<$Res, ViewedProdModel>;
  @useResult
  $Res call({String id, String productId});
}

/// @nodoc
class _$ViewedProdModelCopyWithImpl<$Res, $Val extends ViewedProdModel>
    implements $ViewedProdModelCopyWith<$Res> {
  _$ViewedProdModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ViewedProdModelCopyWith<$Res>
    implements $ViewedProdModelCopyWith<$Res> {
  factory _$$_ViewedProdModelCopyWith(
          _$_ViewedProdModel value, $Res Function(_$_ViewedProdModel) then) =
      __$$_ViewedProdModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String productId});
}

/// @nodoc
class __$$_ViewedProdModelCopyWithImpl<$Res>
    extends _$ViewedProdModelCopyWithImpl<$Res, _$_ViewedProdModel>
    implements _$$_ViewedProdModelCopyWith<$Res> {
  __$$_ViewedProdModelCopyWithImpl(
      _$_ViewedProdModel _value, $Res Function(_$_ViewedProdModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
  }) {
    return _then(_$_ViewedProdModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ViewedProdModel implements _ViewedProdModel {
  _$_ViewedProdModel({required this.id, required this.productId});

  @override
  final String id;
  @override
  final String productId;

  @override
  String toString() {
    return 'ViewedProdModel(id: $id, productId: $productId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewedProdModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, productId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViewedProdModelCopyWith<_$_ViewedProdModel> get copyWith =>
      __$$_ViewedProdModelCopyWithImpl<_$_ViewedProdModel>(this, _$identity);
}

abstract class _ViewedProdModel implements ViewedProdModel {
  factory _ViewedProdModel(
      {required final String id,
      required final String productId}) = _$_ViewedProdModel;

  @override
  String get id;
  @override
  String get productId;
  @override
  @JsonKey(ignore: true)
  _$$_ViewedProdModelCopyWith<_$_ViewedProdModel> get copyWith =>
      throw _privateConstructorUsedError;
}
