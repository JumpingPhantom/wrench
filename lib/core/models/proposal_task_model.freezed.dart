// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proposal_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProposalTaskModel {

 String get title; String get description; String get mediaUrl;
/// Create a copy of ProposalTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProposalTaskModelCopyWith<ProposalTaskModel> get copyWith => _$ProposalTaskModelCopyWithImpl<ProposalTaskModel>(this as ProposalTaskModel, _$identity);

  /// Serializes this ProposalTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProposalTaskModel&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,mediaUrl);

@override
String toString() {
  return 'ProposalTaskModel(title: $title, description: $description, mediaUrl: $mediaUrl)';
}


}

/// @nodoc
abstract mixin class $ProposalTaskModelCopyWith<$Res>  {
  factory $ProposalTaskModelCopyWith(ProposalTaskModel value, $Res Function(ProposalTaskModel) _then) = _$ProposalTaskModelCopyWithImpl;
@useResult
$Res call({
 String title, String description, String mediaUrl
});




}
/// @nodoc
class _$ProposalTaskModelCopyWithImpl<$Res>
    implements $ProposalTaskModelCopyWith<$Res> {
  _$ProposalTaskModelCopyWithImpl(this._self, this._then);

  final ProposalTaskModel _self;
  final $Res Function(ProposalTaskModel) _then;

/// Create a copy of ProposalTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? mediaUrl = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProposalTaskModel].
extension ProposalTaskModelPatterns on ProposalTaskModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProposalTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProposalTaskModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProposalTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _ProposalTaskModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProposalTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProposalTaskModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  String mediaUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProposalTaskModel() when $default != null:
return $default(_that.title,_that.description,_that.mediaUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  String mediaUrl)  $default,) {final _that = this;
switch (_that) {
case _ProposalTaskModel():
return $default(_that.title,_that.description,_that.mediaUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  String mediaUrl)?  $default,) {final _that = this;
switch (_that) {
case _ProposalTaskModel() when $default != null:
return $default(_that.title,_that.description,_that.mediaUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProposalTaskModel implements ProposalTaskModel {
  const _ProposalTaskModel({required this.title, required this.description, required this.mediaUrl});
  factory _ProposalTaskModel.fromJson(Map<String, dynamic> json) => _$ProposalTaskModelFromJson(json);

@override final  String title;
@override final  String description;
@override final  String mediaUrl;

/// Create a copy of ProposalTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProposalTaskModelCopyWith<_ProposalTaskModel> get copyWith => __$ProposalTaskModelCopyWithImpl<_ProposalTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProposalTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProposalTaskModel&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,mediaUrl);

@override
String toString() {
  return 'ProposalTaskModel(title: $title, description: $description, mediaUrl: $mediaUrl)';
}


}

/// @nodoc
abstract mixin class _$ProposalTaskModelCopyWith<$Res> implements $ProposalTaskModelCopyWith<$Res> {
  factory _$ProposalTaskModelCopyWith(_ProposalTaskModel value, $Res Function(_ProposalTaskModel) _then) = __$ProposalTaskModelCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String mediaUrl
});




}
/// @nodoc
class __$ProposalTaskModelCopyWithImpl<$Res>
    implements _$ProposalTaskModelCopyWith<$Res> {
  __$ProposalTaskModelCopyWithImpl(this._self, this._then);

  final _ProposalTaskModel _self;
  final $Res Function(_ProposalTaskModel) _then;

/// Create a copy of ProposalTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? mediaUrl = null,}) {
  return _then(_ProposalTaskModel(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
