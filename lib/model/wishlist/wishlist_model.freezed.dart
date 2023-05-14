// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WishlistModel _$WishlistModelFromJson(Map<String, dynamic> json) {
  return _WishlistModel.fromJson(json);
}

/// @nodoc
mixin _$WishlistModel {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WishlistModelCopyWith<WishlistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistModelCopyWith<$Res> {
  factory $WishlistModelCopyWith(
          WishlistModel value, $Res Function(WishlistModel) then) =
      _$WishlistModelCopyWithImpl<$Res, WishlistModel>;
  @useResult
  $Res call({String id, String productId});
}

/// @nodoc
class _$WishlistModelCopyWithImpl<$Res, $Val extends WishlistModel>
    implements $WishlistModelCopyWith<$Res> {
  _$WishlistModelCopyWithImpl(this._value, this._then);

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
abstract class _$$_WishlistModelCopyWith<$Res>
    implements $WishlistModelCopyWith<$Res> {
  factory _$$_WishlistModelCopyWith(
          _$_WishlistModel value, $Res Function(_$_WishlistModel) then) =
      __$$_WishlistModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String productId});
}

/// @nodoc
class __$$_WishlistModelCopyWithImpl<$Res>
    extends _$WishlistModelCopyWithImpl<$Res, _$_WishlistModel>
    implements _$$_WishlistModelCopyWith<$Res> {
  __$$_WishlistModelCopyWithImpl(
      _$_WishlistModel _value, $Res Function(_$_WishlistModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
  }) {
    return _then(_$_WishlistModel(
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
@JsonSerializable()
class _$_WishlistModel implements _WishlistModel {
  _$_WishlistModel({required this.id, required this.productId});

  factory _$_WishlistModel.fromJson(Map<String, dynamic> json) =>
      _$$_WishlistModelFromJson(json);

  @override
  final String id;
  @override
  final String productId;

  @override
  String toString() {
    return 'WishlistModel(id: $id, productId: $productId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WishlistModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, productId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WishlistModelCopyWith<_$_WishlistModel> get copyWith =>
      __$$_WishlistModelCopyWithImpl<_$_WishlistModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WishlistModelToJson(
      this,
    );
  }
}

abstract class _WishlistModel implements WishlistModel {
  factory _WishlistModel(
      {required final String id,
      required final String productId}) = _$_WishlistModel;

  factory _WishlistModel.fromJson(Map<String, dynamic> json) =
      _$_WishlistModel.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  @JsonKey(ignore: true)
  _$$_WishlistModelCopyWith<_$_WishlistModel> get copyWith =>
      throw _privateConstructorUsedError;
}
