// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'in_progress_job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InProgressJobModel {

 JobModel get job; String get approvedBy; DateTime get createdAt; List<String> get workers;
/// Create a copy of InProgressJobModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InProgressJobModelCopyWith<InProgressJobModel> get copyWith => _$InProgressJobModelCopyWithImpl<InProgressJobModel>(this as InProgressJobModel, _$identity);

  /// Serializes this InProgressJobModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InProgressJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.workers, workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,approvedBy,createdAt,const DeepCollectionEquality().hash(workers));

@override
String toString() {
  return 'InProgressJobModel(job: $job, approvedBy: $approvedBy, createdAt: $createdAt, workers: $workers)';
}


}

/// @nodoc
abstract mixin class $InProgressJobModelCopyWith<$Res>  {
  factory $InProgressJobModelCopyWith(InProgressJobModel value, $Res Function(InProgressJobModel) _then) = _$InProgressJobModelCopyWithImpl;
@useResult
$Res call({
 JobModel job, String approvedBy, DateTime createdAt, List<String> workers
});


$JobModelCopyWith<$Res> get job;

}
/// @nodoc
class _$InProgressJobModelCopyWithImpl<$Res>
    implements $InProgressJobModelCopyWith<$Res> {
  _$InProgressJobModelCopyWithImpl(this._self, this._then);

  final InProgressJobModel _self;
  final $Res Function(InProgressJobModel) _then;

/// Create a copy of InProgressJobModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? job = null,Object? approvedBy = null,Object? createdAt = null,Object? workers = null,}) {
  return _then(_self.copyWith(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel,approvedBy: null == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,workers: null == workers ? _self.workers : workers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of InProgressJobModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobModelCopyWith<$Res> get job {
  
  return $JobModelCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}


/// Adds pattern-matching-related methods to [InProgressJobModel].
extension InProgressJobModelPatterns on InProgressJobModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InProgressJobModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InProgressJobModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InProgressJobModel value)  $default,){
final _that = this;
switch (_that) {
case _InProgressJobModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InProgressJobModel value)?  $default,){
final _that = this;
switch (_that) {
case _InProgressJobModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JobModel job,  String approvedBy,  DateTime createdAt,  List<String> workers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InProgressJobModel() when $default != null:
return $default(_that.job,_that.approvedBy,_that.createdAt,_that.workers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JobModel job,  String approvedBy,  DateTime createdAt,  List<String> workers)  $default,) {final _that = this;
switch (_that) {
case _InProgressJobModel():
return $default(_that.job,_that.approvedBy,_that.createdAt,_that.workers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JobModel job,  String approvedBy,  DateTime createdAt,  List<String> workers)?  $default,) {final _that = this;
switch (_that) {
case _InProgressJobModel() when $default != null:
return $default(_that.job,_that.approvedBy,_that.createdAt,_that.workers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InProgressJobModel implements InProgressJobModel {
  const _InProgressJobModel({required this.job, required this.approvedBy, required this.createdAt, required final  List<String> workers}): _workers = workers;
  factory _InProgressJobModel.fromJson(Map<String, dynamic> json) => _$InProgressJobModelFromJson(json);

@override final  JobModel job;
@override final  String approvedBy;
@override final  DateTime createdAt;
 final  List<String> _workers;
@override List<String> get workers {
  if (_workers is EqualUnmodifiableListView) return _workers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workers);
}


/// Create a copy of InProgressJobModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InProgressJobModelCopyWith<_InProgressJobModel> get copyWith => __$InProgressJobModelCopyWithImpl<_InProgressJobModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InProgressJobModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InProgressJobModel&&(identical(other.job, job) || other.job == job)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._workers, _workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,job,approvedBy,createdAt,const DeepCollectionEquality().hash(_workers));

@override
String toString() {
  return 'InProgressJobModel(job: $job, approvedBy: $approvedBy, createdAt: $createdAt, workers: $workers)';
}


}

/// @nodoc
abstract mixin class _$InProgressJobModelCopyWith<$Res> implements $InProgressJobModelCopyWith<$Res> {
  factory _$InProgressJobModelCopyWith(_InProgressJobModel value, $Res Function(_InProgressJobModel) _then) = __$InProgressJobModelCopyWithImpl;
@override @useResult
$Res call({
 JobModel job, String approvedBy, DateTime createdAt, List<String> workers
});


@override $JobModelCopyWith<$Res> get job;

}
/// @nodoc
class __$InProgressJobModelCopyWithImpl<$Res>
    implements _$InProgressJobModelCopyWith<$Res> {
  __$InProgressJobModelCopyWithImpl(this._self, this._then);

  final _InProgressJobModel _self;
  final $Res Function(_InProgressJobModel) _then;

/// Create a copy of InProgressJobModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? job = null,Object? approvedBy = null,Object? createdAt = null,Object? workers = null,}) {
  return _then(_InProgressJobModel(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel,approvedBy: null == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,workers: null == workers ? _self._workers : workers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of InProgressJobModel
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
