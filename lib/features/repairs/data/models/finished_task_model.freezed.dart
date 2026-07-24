// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finished_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinishedTaskModel {

 StagedTaskModel get task; DateTime get finishedAt; String get finishedBy; String get reviewer; String get comments;
/// Create a copy of FinishedTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishedTaskModelCopyWith<FinishedTaskModel> get copyWith => _$FinishedTaskModelCopyWithImpl<FinishedTaskModel>(this as FinishedTaskModel, _$identity);

  /// Serializes this FinishedTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishedTaskModel&&(identical(other.task, task) || other.task == task)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.finishedBy, finishedBy) || other.finishedBy == finishedBy)&&(identical(other.reviewer, reviewer) || other.reviewer == reviewer)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,finishedAt,finishedBy,reviewer,comments);

@override
String toString() {
  return 'FinishedTaskModel(task: $task, finishedAt: $finishedAt, finishedBy: $finishedBy, reviewer: $reviewer, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $FinishedTaskModelCopyWith<$Res>  {
  factory $FinishedTaskModelCopyWith(FinishedTaskModel value, $Res Function(FinishedTaskModel) _then) = _$FinishedTaskModelCopyWithImpl;
@useResult
$Res call({
 StagedTaskModel task, DateTime finishedAt, String finishedBy, String reviewer, String comments
});


$StagedTaskModelCopyWith<$Res> get task;

}
/// @nodoc
class _$FinishedTaskModelCopyWithImpl<$Res>
    implements $FinishedTaskModelCopyWith<$Res> {
  _$FinishedTaskModelCopyWithImpl(this._self, this._then);

  final FinishedTaskModel _self;
  final $Res Function(FinishedTaskModel) _then;

/// Create a copy of FinishedTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? finishedAt = null,Object? finishedBy = null,Object? reviewer = null,Object? comments = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as StagedTaskModel,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedBy: null == finishedBy ? _self.finishedBy : finishedBy // ignore: cast_nullable_to_non_nullable
as String,reviewer: null == reviewer ? _self.reviewer : reviewer // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of FinishedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StagedTaskModelCopyWith<$Res> get task {
  
  return $StagedTaskModelCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [FinishedTaskModel].
extension FinishedTaskModelPatterns on FinishedTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishedTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishedTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishedTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _FinishedTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishedTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _FinishedTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StagedTaskModel task,  DateTime finishedAt,  String finishedBy,  String reviewer,  String comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishedTaskModel() when $default != null:
return $default(_that.task,_that.finishedAt,_that.finishedBy,_that.reviewer,_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StagedTaskModel task,  DateTime finishedAt,  String finishedBy,  String reviewer,  String comments)  $default,) {final _that = this;
switch (_that) {
case _FinishedTaskModel():
return $default(_that.task,_that.finishedAt,_that.finishedBy,_that.reviewer,_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StagedTaskModel task,  DateTime finishedAt,  String finishedBy,  String reviewer,  String comments)?  $default,) {final _that = this;
switch (_that) {
case _FinishedTaskModel() when $default != null:
return $default(_that.task,_that.finishedAt,_that.finishedBy,_that.reviewer,_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishedTaskModel implements FinishedTaskModel {
  const _FinishedTaskModel({required this.task, required this.finishedAt, required this.finishedBy, required this.reviewer, required this.comments});
  factory _FinishedTaskModel.fromJson(Map<String, dynamic> json) => _$FinishedTaskModelFromJson(json);

@override final  StagedTaskModel task;
@override final  DateTime finishedAt;
@override final  String finishedBy;
@override final  String reviewer;
@override final  String comments;

/// Create a copy of FinishedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishedTaskModelCopyWith<_FinishedTaskModel> get copyWith => __$FinishedTaskModelCopyWithImpl<_FinishedTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishedTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishedTaskModel&&(identical(other.task, task) || other.task == task)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.finishedBy, finishedBy) || other.finishedBy == finishedBy)&&(identical(other.reviewer, reviewer) || other.reviewer == reviewer)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,finishedAt,finishedBy,reviewer,comments);

@override
String toString() {
  return 'FinishedTaskModel(task: $task, finishedAt: $finishedAt, finishedBy: $finishedBy, reviewer: $reviewer, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$FinishedTaskModelCopyWith<$Res> implements $FinishedTaskModelCopyWith<$Res> {
  factory _$FinishedTaskModelCopyWith(_FinishedTaskModel value, $Res Function(_FinishedTaskModel) _then) = __$FinishedTaskModelCopyWithImpl;
@override @useResult
$Res call({
 StagedTaskModel task, DateTime finishedAt, String finishedBy, String reviewer, String comments
});


@override $StagedTaskModelCopyWith<$Res> get task;

}
/// @nodoc
class __$FinishedTaskModelCopyWithImpl<$Res>
    implements _$FinishedTaskModelCopyWith<$Res> {
  __$FinishedTaskModelCopyWithImpl(this._self, this._then);

  final _FinishedTaskModel _self;
  final $Res Function(_FinishedTaskModel) _then;

/// Create a copy of FinishedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? finishedAt = null,Object? finishedBy = null,Object? reviewer = null,Object? comments = null,}) {
  return _then(_FinishedTaskModel(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as StagedTaskModel,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedBy: null == finishedBy ? _self.finishedBy : finishedBy // ignore: cast_nullable_to_non_nullable
as String,reviewer: null == reviewer ? _self.reviewer : reviewer // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of FinishedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StagedTaskModelCopyWith<$Res> get task {
  
  return $StagedTaskModelCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
