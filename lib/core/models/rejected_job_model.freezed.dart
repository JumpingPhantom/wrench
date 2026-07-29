// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rejected_job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RejectedJobModel {

 JobModel get job; String get rejectedBy; DateTime get rejectedAt; String get reason;
/// Create a copy of RejectedJobModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RejectedJobModelCopyWith<RejectedJobModel> get copyWith => _$RejectedJobModelCopyWithImpl<RejectedJobModel>(this as RejectedJobModel, _$identity);

  /// Serializes this RejectedJobModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RejectedJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.rejectedBy, rejectedBy) || other.rejectedBy == rejectedBy)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,rejectedBy,rejectedAt,reason);

@override
String toString() {
  return 'RejectedJobModel(job: $job, rejectedBy: $rejectedBy, rejectedAt: $rejectedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $RejectedJobModelCopyWith<$Res>  {
  factory $RejectedJobModelCopyWith(RejectedJobModel value, $Res Function(RejectedJobModel) _then) = _$RejectedJobModelCopyWithImpl;
@useResult
$Res call({
 JobModel job, String rejectedBy, DateTime rejectedAt, String reason
});


$JobModelCopyWith<$Res> get job;

}
/// @nodoc
class _$RejectedJobModelCopyWithImpl<$Res>
    implements $RejectedJobModelCopyWith<$Res> {
  _$RejectedJobModelCopyWithImpl(this._self, this._then);

  final RejectedJobModel _self;
  final $Res Function(RejectedJobModel) _then;

/// Create a copy of RejectedJobModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? job = null,Object? rejectedBy = null,Object? rejectedAt = null,Object? reason = null,}) {
  return _then(_self.copyWith(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel,rejectedBy: null == rejectedBy ? _self.rejectedBy : rejectedBy // ignore: cast_nullable_to_non_nullable
as String,rejectedAt: null == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of RejectedJobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobModelCopyWith<$Res> get job {
  
  return $JobModelCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}


/// Adds pattern-matching-related methods to [RejectedJobModel].
extension RejectedJobModelPatterns on RejectedJobModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RejectedJobModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RejectedJobModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RejectedJobModel value)  $default,){
final _that = this;
switch (_that) {
case _RejectedJobModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RejectedJobModel value)?  $default,){
final _that = this;
switch (_that) {
case _RejectedJobModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JobModel job,  String rejectedBy,  DateTime rejectedAt,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RejectedJobModel() when $default != null:
return $default(_that.job,_that.rejectedBy,_that.rejectedAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JobModel job,  String rejectedBy,  DateTime rejectedAt,  String reason)  $default,) {final _that = this;
switch (_that) {
case _RejectedJobModel():
return $default(_that.job,_that.rejectedBy,_that.rejectedAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JobModel job,  String rejectedBy,  DateTime rejectedAt,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _RejectedJobModel() when $default != null:
return $default(_that.job,_that.rejectedBy,_that.rejectedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RejectedJobModel implements RejectedJobModel {
  const _RejectedJobModel({required this.job, required this.rejectedBy, required this.rejectedAt, required this.reason});
  factory _RejectedJobModel.fromJson(Map<String, dynamic> json) => _$RejectedJobModelFromJson(json);

@override final  JobModel job;
@override final  String rejectedBy;
@override final  DateTime rejectedAt;
@override final  String reason;

/// Create a copy of RejectedJobModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RejectedJobModelCopyWith<_RejectedJobModel> get copyWith => __$RejectedJobModelCopyWithImpl<_RejectedJobModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RejectedJobModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RejectedJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.rejectedBy, rejectedBy) || other.rejectedBy == rejectedBy)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,rejectedBy,rejectedAt,reason);

@override
String toString() {
  return 'RejectedJobModel(job: $job, rejectedBy: $rejectedBy, rejectedAt: $rejectedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RejectedJobModelCopyWith<$Res> implements $RejectedJobModelCopyWith<$Res> {
  factory _$RejectedJobModelCopyWith(_RejectedJobModel value, $Res Function(_RejectedJobModel) _then) = __$RejectedJobModelCopyWithImpl;
@override @useResult
$Res call({
 JobModel job, String rejectedBy, DateTime rejectedAt, String reason
});


@override $JobModelCopyWith<$Res> get job;

}
/// @nodoc
class __$RejectedJobModelCopyWithImpl<$Res>
    implements _$RejectedJobModelCopyWith<$Res> {
  __$RejectedJobModelCopyWithImpl(this._self, this._then);

  final _RejectedJobModel _self;
  final $Res Function(_RejectedJobModel) _then;

/// Create a copy of RejectedJobModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? job = null,Object? rejectedBy = null,Object? rejectedAt = null,Object? reason = null,}) {
  return _then(_RejectedJobModel(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel,rejectedBy: null == rejectedBy ? _self.rejectedBy : rejectedBy // ignore: cast_nullable_to_non_nullable
as String,rejectedAt: null == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of RejectedJobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobModelCopyWith<$Res> get job {
  
  return $JobModelCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}

// dart format on
