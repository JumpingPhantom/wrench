// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staged_job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StagedJobModel {

 InProgressJobModel get job; String get stagedBy; DateTime get stagedAt;
/// Create a copy of StagedJobModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StagedJobModelCopyWith<StagedJobModel> get copyWith => _$StagedJobModelCopyWithImpl<StagedJobModel>(this as StagedJobModel, _$identity);

  /// Serializes this StagedJobModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StagedJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.stagedBy, stagedBy) || other.stagedBy == stagedBy)&&(identical(other.stagedAt, stagedAt) || other.stagedAt == stagedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,stagedBy,stagedAt);

@override
String toString() {
  return 'StagedJobModel(job: $job, stagedBy: $stagedBy, stagedAt: $stagedAt)';
}


}

/// @nodoc
abstract mixin class $StagedJobModelCopyWith<$Res>  {
  factory $StagedJobModelCopyWith(StagedJobModel value, $Res Function(StagedJobModel) _then) = _$StagedJobModelCopyWithImpl;
@useResult
$Res call({
 InProgressJobModel job, String stagedBy, DateTime stagedAt
});


$InProgressJobModelCopyWith<$Res> get job;

}
/// @nodoc
class _$StagedJobModelCopyWithImpl<$Res>
    implements $StagedJobModelCopyWith<$Res> {
  _$StagedJobModelCopyWithImpl(this._self, this._then);

  final StagedJobModel _self;
  final $Res Function(StagedJobModel) _then;

/// Create a copy of StagedJobModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? job = null,Object? stagedBy = null,Object? stagedAt = null,}) {
  return _then(_self.copyWith(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as InProgressJobModel,stagedBy: null == stagedBy ? _self.stagedBy : stagedBy // ignore: cast_nullable_to_non_nullable
as String,stagedAt: null == stagedAt ? _self.stagedAt : stagedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of StagedJobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InProgressJobModelCopyWith<$Res> get job {
  
  return $InProgressJobModelCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}


/// Adds pattern-matching-related methods to [StagedJobModel].
extension StagedJobModelPatterns on StagedJobModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StagedJobModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StagedJobModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StagedJobModel value)  $default,){
final _that = this;
switch (_that) {
case _StagedJobModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StagedJobModel value)?  $default,){
final _that = this;
switch (_that) {
case _StagedJobModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InProgressJobModel job,  String stagedBy,  DateTime stagedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StagedJobModel() when $default != null:
return $default(_that.job,_that.stagedBy,_that.stagedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InProgressJobModel job,  String stagedBy,  DateTime stagedAt)  $default,) {final _that = this;
switch (_that) {
case _StagedJobModel():
return $default(_that.job,_that.stagedBy,_that.stagedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InProgressJobModel job,  String stagedBy,  DateTime stagedAt)?  $default,) {final _that = this;
switch (_that) {
case _StagedJobModel() when $default != null:
return $default(_that.job,_that.stagedBy,_that.stagedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StagedJobModel implements StagedJobModel {
  const _StagedJobModel({required this.job, required this.stagedBy, required this.stagedAt});
  factory _StagedJobModel.fromJson(Map<String, dynamic> json) => _$StagedJobModelFromJson(json);

@override final  InProgressJobModel job;
@override final  String stagedBy;
@override final  DateTime stagedAt;

/// Create a copy of StagedJobModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StagedJobModelCopyWith<_StagedJobModel> get copyWith => __$StagedJobModelCopyWithImpl<_StagedJobModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StagedJobModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StagedJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.stagedBy, stagedBy) || other.stagedBy == stagedBy)&&(identical(other.stagedAt, stagedAt) || other.stagedAt == stagedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,stagedBy,stagedAt);

@override
String toString() {
  return 'StagedJobModel(job: $job, stagedBy: $stagedBy, stagedAt: $stagedAt)';
}


}

/// @nodoc
abstract mixin class _$StagedJobModelCopyWith<$Res> implements $StagedJobModelCopyWith<$Res> {
  factory _$StagedJobModelCopyWith(_StagedJobModel value, $Res Function(_StagedJobModel) _then) = __$StagedJobModelCopyWithImpl;
@override @useResult
$Res call({
 InProgressJobModel job, String stagedBy, DateTime stagedAt
});


@override $InProgressJobModelCopyWith<$Res> get job;

}
/// @nodoc
class __$StagedJobModelCopyWithImpl<$Res>
    implements _$StagedJobModelCopyWith<$Res> {
  __$StagedJobModelCopyWithImpl(this._self, this._then);

  final _StagedJobModel _self;
  final $Res Function(_StagedJobModel) _then;

/// Create a copy of StagedJobModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? job = null,Object? stagedBy = null,Object? stagedAt = null,}) {
  return _then(_StagedJobModel(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as InProgressJobModel,stagedBy: null == stagedBy ? _self.stagedBy : stagedBy // ignore: cast_nullable_to_non_nullable
as String,stagedAt: null == stagedAt ? _self.stagedAt : stagedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of StagedJobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InProgressJobModelCopyWith<$Res> get job {
  
  return $InProgressJobModelCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}

// dart format on
