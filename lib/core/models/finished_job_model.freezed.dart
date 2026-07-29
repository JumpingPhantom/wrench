// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finished_job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinishedJobModel {

 StagedJobModel get job; DateTime get finishedAt; String get finishedBy; String get reviewer; String get comments;
/// Create a copy of FinishedJobModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishedJobModelCopyWith<FinishedJobModel> get copyWith => _$FinishedJobModelCopyWithImpl<FinishedJobModel>(this as FinishedJobModel, _$identity);

  /// Serializes this FinishedJobModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishedJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.finishedBy, finishedBy) || other.finishedBy == finishedBy)&&(identical(other.reviewer, reviewer) || other.reviewer == reviewer)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,finishedAt,finishedBy,reviewer,comments);

@override
String toString() {
  return 'FinishedJobModel(job: $job, finishedAt: $finishedAt, finishedBy: $finishedBy, reviewer: $reviewer, comments: $comments)';
}


}

/// @nodoc
abstract mixin class $FinishedJobModelCopyWith<$Res>  {
  factory $FinishedJobModelCopyWith(FinishedJobModel value, $Res Function(FinishedJobModel) _then) = _$FinishedJobModelCopyWithImpl;
@useResult
$Res call({
 StagedJobModel job, DateTime finishedAt, String finishedBy, String reviewer, String comments
});


$StagedJobModelCopyWith<$Res> get job;

}
/// @nodoc
class _$FinishedJobModelCopyWithImpl<$Res>
    implements $FinishedJobModelCopyWith<$Res> {
  _$FinishedJobModelCopyWithImpl(this._self, this._then);

  final FinishedJobModel _self;
  final $Res Function(FinishedJobModel) _then;

/// Create a copy of FinishedJobModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? job = null,Object? finishedAt = null,Object? finishedBy = null,Object? reviewer = null,Object? comments = null,}) {
  return _then(_self.copyWith(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as StagedJobModel,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedBy: null == finishedBy ? _self.finishedBy : finishedBy // ignore: cast_nullable_to_non_nullable
as String,reviewer: null == reviewer ? _self.reviewer : reviewer // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of FinishedJobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StagedJobModelCopyWith<$Res> get job {
  
  return $StagedJobModelCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}


/// Adds pattern-matching-related methods to [FinishedJobModel].
extension FinishedJobModelPatterns on FinishedJobModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishedJobModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishedJobModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishedJobModel value)  $default,){
final _that = this;
switch (_that) {
case _FinishedJobModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishedJobModel value)?  $default,){
final _that = this;
switch (_that) {
case _FinishedJobModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StagedJobModel job,  DateTime finishedAt,  String finishedBy,  String reviewer,  String comments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishedJobModel() when $default != null:
return $default(_that.job,_that.finishedAt,_that.finishedBy,_that.reviewer,_that.comments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StagedJobModel job,  DateTime finishedAt,  String finishedBy,  String reviewer,  String comments)  $default,) {final _that = this;
switch (_that) {
case _FinishedJobModel():
return $default(_that.job,_that.finishedAt,_that.finishedBy,_that.reviewer,_that.comments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StagedJobModel job,  DateTime finishedAt,  String finishedBy,  String reviewer,  String comments)?  $default,) {final _that = this;
switch (_that) {
case _FinishedJobModel() when $default != null:
return $default(_that.job,_that.finishedAt,_that.finishedBy,_that.reviewer,_that.comments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishedJobModel implements FinishedJobModel {
  const _FinishedJobModel({required this.job, required this.finishedAt, required this.finishedBy, required this.reviewer, required this.comments});
  factory _FinishedJobModel.fromJson(Map<String, dynamic> json) => _$FinishedJobModelFromJson(json);

@override final  StagedJobModel job;
@override final  DateTime finishedAt;
@override final  String finishedBy;
@override final  String reviewer;
@override final  String comments;

/// Create a copy of FinishedJobModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishedJobModelCopyWith<_FinishedJobModel> get copyWith => __$FinishedJobModelCopyWithImpl<_FinishedJobModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishedJobModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishedJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.finishedBy, finishedBy) || other.finishedBy == finishedBy)&&(identical(other.reviewer, reviewer) || other.reviewer == reviewer)&&(identical(other.comments, comments) || other.comments == comments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,finishedAt,finishedBy,reviewer,comments);

@override
String toString() {
  return 'FinishedJobModel(job: $job, finishedAt: $finishedAt, finishedBy: $finishedBy, reviewer: $reviewer, comments: $comments)';
}


}

/// @nodoc
abstract mixin class _$FinishedJobModelCopyWith<$Res> implements $FinishedJobModelCopyWith<$Res> {
  factory _$FinishedJobModelCopyWith(_FinishedJobModel value, $Res Function(_FinishedJobModel) _then) = __$FinishedJobModelCopyWithImpl;
@override @useResult
$Res call({
 StagedJobModel job, DateTime finishedAt, String finishedBy, String reviewer, String comments
});


@override $StagedJobModelCopyWith<$Res> get job;

}
/// @nodoc
class __$FinishedJobModelCopyWithImpl<$Res>
    implements _$FinishedJobModelCopyWith<$Res> {
  __$FinishedJobModelCopyWithImpl(this._self, this._then);

  final _FinishedJobModel _self;
  final $Res Function(_FinishedJobModel) _then;

/// Create a copy of FinishedJobModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? job = null,Object? finishedAt = null,Object? finishedBy = null,Object? reviewer = null,Object? comments = null,}) {
  return _then(_FinishedJobModel(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as StagedJobModel,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedBy: null == finishedBy ? _self.finishedBy : finishedBy // ignore: cast_nullable_to_non_nullable
as String,reviewer: null == reviewer ? _self.reviewer : reviewer // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of FinishedJobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StagedJobModelCopyWith<$Res> get job {
  
  return $StagedJobModelCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}

// dart format on
