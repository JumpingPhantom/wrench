// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staged_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StagedTaskModel {

 InProgressTaskModel get task; String get stagedBy; DateTime get stagedAt;
/// Create a copy of StagedTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StagedTaskModelCopyWith<StagedTaskModel> get copyWith => _$StagedTaskModelCopyWithImpl<StagedTaskModel>(this as StagedTaskModel, _$identity);

  /// Serializes this StagedTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StagedTaskModel&&(identical(other.task, task) || other.task == task)&&(identical(other.stagedBy, stagedBy) || other.stagedBy == stagedBy)&&(identical(other.stagedAt, stagedAt) || other.stagedAt == stagedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,stagedBy,stagedAt);

@override
String toString() {
  return 'StagedTaskModel(task: $task, stagedBy: $stagedBy, stagedAt: $stagedAt)';
}


}

/// @nodoc
abstract mixin class $StagedTaskModelCopyWith<$Res>  {
  factory $StagedTaskModelCopyWith(StagedTaskModel value, $Res Function(StagedTaskModel) _then) = _$StagedTaskModelCopyWithImpl;
@useResult
$Res call({
 InProgressTaskModel task, String stagedBy, DateTime stagedAt
});


$InProgressTaskModelCopyWith<$Res> get task;

}
/// @nodoc
class _$StagedTaskModelCopyWithImpl<$Res>
    implements $StagedTaskModelCopyWith<$Res> {
  _$StagedTaskModelCopyWithImpl(this._self, this._then);

  final StagedTaskModel _self;
  final $Res Function(StagedTaskModel) _then;

/// Create a copy of StagedTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? stagedBy = null,Object? stagedAt = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as InProgressTaskModel,stagedBy: null == stagedBy ? _self.stagedBy : stagedBy // ignore: cast_nullable_to_non_nullable
as String,stagedAt: null == stagedAt ? _self.stagedAt : stagedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of StagedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InProgressTaskModelCopyWith<$Res> get task {
  
  return $InProgressTaskModelCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [StagedTaskModel].
extension StagedTaskModelPatterns on StagedTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StagedTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StagedTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StagedTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _StagedTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StagedTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _StagedTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InProgressTaskModel task,  String stagedBy,  DateTime stagedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StagedTaskModel() when $default != null:
return $default(_that.task,_that.stagedBy,_that.stagedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InProgressTaskModel task,  String stagedBy,  DateTime stagedAt)  $default,) {final _that = this;
switch (_that) {
case _StagedTaskModel():
return $default(_that.task,_that.stagedBy,_that.stagedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InProgressTaskModel task,  String stagedBy,  DateTime stagedAt)?  $default,) {final _that = this;
switch (_that) {
case _StagedTaskModel() when $default != null:
return $default(_that.task,_that.stagedBy,_that.stagedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StagedTaskModel implements StagedTaskModel {
  const _StagedTaskModel({required this.task, required this.stagedBy, required this.stagedAt});
  factory _StagedTaskModel.fromJson(Map<String, dynamic> json) => _$StagedTaskModelFromJson(json);

@override final  InProgressTaskModel task;
@override final  String stagedBy;
@override final  DateTime stagedAt;

/// Create a copy of StagedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StagedTaskModelCopyWith<_StagedTaskModel> get copyWith => __$StagedTaskModelCopyWithImpl<_StagedTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StagedTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StagedTaskModel&&(identical(other.task, task) || other.task == task)&&(identical(other.stagedBy, stagedBy) || other.stagedBy == stagedBy)&&(identical(other.stagedAt, stagedAt) || other.stagedAt == stagedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,stagedBy,stagedAt);

@override
String toString() {
  return 'StagedTaskModel(task: $task, stagedBy: $stagedBy, stagedAt: $stagedAt)';
}


}

/// @nodoc
abstract mixin class _$StagedTaskModelCopyWith<$Res> implements $StagedTaskModelCopyWith<$Res> {
  factory _$StagedTaskModelCopyWith(_StagedTaskModel value, $Res Function(_StagedTaskModel) _then) = __$StagedTaskModelCopyWithImpl;
@override @useResult
$Res call({
 InProgressTaskModel task, String stagedBy, DateTime stagedAt
});


@override $InProgressTaskModelCopyWith<$Res> get task;

}
/// @nodoc
class __$StagedTaskModelCopyWithImpl<$Res>
    implements _$StagedTaskModelCopyWith<$Res> {
  __$StagedTaskModelCopyWithImpl(this._self, this._then);

  final _StagedTaskModel _self;
  final $Res Function(_StagedTaskModel) _then;

/// Create a copy of StagedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? stagedBy = null,Object? stagedAt = null,}) {
  return _then(_StagedTaskModel(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as InProgressTaskModel,stagedBy: null == stagedBy ? _self.stagedBy : stagedBy // ignore: cast_nullable_to_non_nullable
as String,stagedAt: null == stagedAt ? _self.stagedAt : stagedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of StagedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InProgressTaskModelCopyWith<$Res> get task {
  
  return $InProgressTaskModelCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
