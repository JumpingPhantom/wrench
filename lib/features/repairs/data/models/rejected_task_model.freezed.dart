// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rejected_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RejectedTaskModel {

 ProposalTaskModel get task; String get rejectedBy; DateTime get rejectedAt; String get reason;
/// Create a copy of RejectedTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RejectedTaskModelCopyWith<RejectedTaskModel> get copyWith => _$RejectedTaskModelCopyWithImpl<RejectedTaskModel>(this as RejectedTaskModel, _$identity);

  /// Serializes this RejectedTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RejectedTaskModel&&(identical(other.task, task) || other.task == task)&&(identical(other.rejectedBy, rejectedBy) || other.rejectedBy == rejectedBy)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,rejectedBy,rejectedAt,reason);

@override
String toString() {
  return 'RejectedTaskModel(task: $task, rejectedBy: $rejectedBy, rejectedAt: $rejectedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $RejectedTaskModelCopyWith<$Res>  {
  factory $RejectedTaskModelCopyWith(RejectedTaskModel value, $Res Function(RejectedTaskModel) _then) = _$RejectedTaskModelCopyWithImpl;
@useResult
$Res call({
 ProposalTaskModel task, String rejectedBy, DateTime rejectedAt, String reason
});


$ProposalTaskModelCopyWith<$Res> get task;

}
/// @nodoc
class _$RejectedTaskModelCopyWithImpl<$Res>
    implements $RejectedTaskModelCopyWith<$Res> {
  _$RejectedTaskModelCopyWithImpl(this._self, this._then);

  final RejectedTaskModel _self;
  final $Res Function(RejectedTaskModel) _then;

/// Create a copy of RejectedTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? rejectedBy = null,Object? rejectedAt = null,Object? reason = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProposalTaskModel,rejectedBy: null == rejectedBy ? _self.rejectedBy : rejectedBy // ignore: cast_nullable_to_non_nullable
as String,rejectedAt: null == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of RejectedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalTaskModelCopyWith<$Res> get task {
  
  return $ProposalTaskModelCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [RejectedTaskModel].
extension RejectedTaskModelPatterns on RejectedTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RejectedTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RejectedTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RejectedTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _RejectedTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RejectedTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _RejectedTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProposalTaskModel task,  String rejectedBy,  DateTime rejectedAt,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RejectedTaskModel() when $default != null:
return $default(_that.task,_that.rejectedBy,_that.rejectedAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProposalTaskModel task,  String rejectedBy,  DateTime rejectedAt,  String reason)  $default,) {final _that = this;
switch (_that) {
case _RejectedTaskModel():
return $default(_that.task,_that.rejectedBy,_that.rejectedAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProposalTaskModel task,  String rejectedBy,  DateTime rejectedAt,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _RejectedTaskModel() when $default != null:
return $default(_that.task,_that.rejectedBy,_that.rejectedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RejectedTaskModel implements RejectedTaskModel {
  const _RejectedTaskModel({required this.task, required this.rejectedBy, required this.rejectedAt, required this.reason});
  factory _RejectedTaskModel.fromJson(Map<String, dynamic> json) => _$RejectedTaskModelFromJson(json);

@override final  ProposalTaskModel task;
@override final  String rejectedBy;
@override final  DateTime rejectedAt;
@override final  String reason;

/// Create a copy of RejectedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RejectedTaskModelCopyWith<_RejectedTaskModel> get copyWith => __$RejectedTaskModelCopyWithImpl<_RejectedTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RejectedTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RejectedTaskModel&&(identical(other.task, task) || other.task == task)&&(identical(other.rejectedBy, rejectedBy) || other.rejectedBy == rejectedBy)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task,rejectedBy,rejectedAt,reason);

@override
String toString() {
  return 'RejectedTaskModel(task: $task, rejectedBy: $rejectedBy, rejectedAt: $rejectedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RejectedTaskModelCopyWith<$Res> implements $RejectedTaskModelCopyWith<$Res> {
  factory _$RejectedTaskModelCopyWith(_RejectedTaskModel value, $Res Function(_RejectedTaskModel) _then) = __$RejectedTaskModelCopyWithImpl;
@override @useResult
$Res call({
 ProposalTaskModel task, String rejectedBy, DateTime rejectedAt, String reason
});


@override $ProposalTaskModelCopyWith<$Res> get task;

}
/// @nodoc
class __$RejectedTaskModelCopyWithImpl<$Res>
    implements _$RejectedTaskModelCopyWith<$Res> {
  __$RejectedTaskModelCopyWithImpl(this._self, this._then);

  final _RejectedTaskModel _self;
  final $Res Function(_RejectedTaskModel) _then;

/// Create a copy of RejectedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? rejectedBy = null,Object? rejectedAt = null,Object? reason = null,}) {
  return _then(_RejectedTaskModel(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as ProposalTaskModel,rejectedBy: null == rejectedBy ? _self.rejectedBy : rejectedBy // ignore: cast_nullable_to_non_nullable
as String,rejectedAt: null == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of RejectedTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalTaskModelCopyWith<$Res> get task {
  
  return $ProposalTaskModelCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
