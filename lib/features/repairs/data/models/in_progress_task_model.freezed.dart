// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'in_progress_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InProgressTaskModel {

 ProposalTaskModel get proposal; String get approvedBy; DateTime get createdAt; List<String> get workers;
/// Create a copy of InProgressTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InProgressTaskModelCopyWith<InProgressTaskModel> get copyWith => _$InProgressTaskModelCopyWithImpl<InProgressTaskModel>(this as InProgressTaskModel, _$identity);

  /// Serializes this InProgressTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InProgressTaskModel&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.workers, workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,proposal,approvedBy,createdAt,const DeepCollectionEquality().hash(workers));

@override
String toString() {
  return 'InProgressTaskModel(proposal: $proposal, approvedBy: $approvedBy, createdAt: $createdAt, workers: $workers)';
}


}

/// @nodoc
abstract mixin class $InProgressTaskModelCopyWith<$Res>  {
  factory $InProgressTaskModelCopyWith(InProgressTaskModel value, $Res Function(InProgressTaskModel) _then) = _$InProgressTaskModelCopyWithImpl;
@useResult
$Res call({
 ProposalTaskModel proposal, String approvedBy, DateTime createdAt, List<String> workers
});


$ProposalTaskModelCopyWith<$Res> get proposal;

}
/// @nodoc
class _$InProgressTaskModelCopyWithImpl<$Res>
    implements $InProgressTaskModelCopyWith<$Res> {
  _$InProgressTaskModelCopyWithImpl(this._self, this._then);

  final InProgressTaskModel _self;
  final $Res Function(InProgressTaskModel) _then;

/// Create a copy of InProgressTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? proposal = null,Object? approvedBy = null,Object? createdAt = null,Object? workers = null,}) {
  return _then(_self.copyWith(
proposal: null == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as ProposalTaskModel,approvedBy: null == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,workers: null == workers ? _self.workers : workers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of InProgressTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalTaskModelCopyWith<$Res> get proposal {
  
  return $ProposalTaskModelCopyWith<$Res>(_self.proposal, (value) {
    return _then(_self.copyWith(proposal: value));
  });
}
}


/// Adds pattern-matching-related methods to [InProgressTaskModel].
extension InProgressTaskModelPatterns on InProgressTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InProgressTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InProgressTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InProgressTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _InProgressTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InProgressTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _InProgressTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProposalTaskModel proposal,  String approvedBy,  DateTime createdAt,  List<String> workers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InProgressTaskModel() when $default != null:
return $default(_that.proposal,_that.approvedBy,_that.createdAt,_that.workers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProposalTaskModel proposal,  String approvedBy,  DateTime createdAt,  List<String> workers)  $default,) {final _that = this;
switch (_that) {
case _InProgressTaskModel():
return $default(_that.proposal,_that.approvedBy,_that.createdAt,_that.workers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProposalTaskModel proposal,  String approvedBy,  DateTime createdAt,  List<String> workers)?  $default,) {final _that = this;
switch (_that) {
case _InProgressTaskModel() when $default != null:
return $default(_that.proposal,_that.approvedBy,_that.createdAt,_that.workers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InProgressTaskModel implements InProgressTaskModel {
  const _InProgressTaskModel({required this.proposal, required this.approvedBy, required this.createdAt, required final  List<String> workers}): _workers = workers;
  factory _InProgressTaskModel.fromJson(Map<String, dynamic> json) => _$InProgressTaskModelFromJson(json);

@override final  ProposalTaskModel proposal;
@override final  String approvedBy;
@override final  DateTime createdAt;
 final  List<String> _workers;
@override List<String> get workers {
  if (_workers is EqualUnmodifiableListView) return _workers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workers);
}


/// Create a copy of InProgressTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InProgressTaskModelCopyWith<_InProgressTaskModel> get copyWith => __$InProgressTaskModelCopyWithImpl<_InProgressTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InProgressTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InProgressTaskModel&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._workers, _workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,proposal,approvedBy,createdAt,const DeepCollectionEquality().hash(_workers));

@override
String toString() {
  return 'InProgressTaskModel(proposal: $proposal, approvedBy: $approvedBy, createdAt: $createdAt, workers: $workers)';
}


}

/// @nodoc
abstract mixin class _$InProgressTaskModelCopyWith<$Res> implements $InProgressTaskModelCopyWith<$Res> {
  factory _$InProgressTaskModelCopyWith(_InProgressTaskModel value, $Res Function(_InProgressTaskModel) _then) = __$InProgressTaskModelCopyWithImpl;
@override @useResult
$Res call({
 ProposalTaskModel proposal, String approvedBy, DateTime createdAt, List<String> workers
});


@override $ProposalTaskModelCopyWith<$Res> get proposal;

}
/// @nodoc
class __$InProgressTaskModelCopyWithImpl<$Res>
    implements _$InProgressTaskModelCopyWith<$Res> {
  __$InProgressTaskModelCopyWithImpl(this._self, this._then);

  final _InProgressTaskModel _self;
  final $Res Function(_InProgressTaskModel) _then;

/// Create a copy of InProgressTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? proposal = null,Object? approvedBy = null,Object? createdAt = null,Object? workers = null,}) {
  return _then(_InProgressTaskModel(
proposal: null == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as ProposalTaskModel,approvedBy: null == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,workers: null == workers ? _self._workers : workers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of InProgressTaskModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProposalTaskModelCopyWith<$Res> get proposal {
  
  return $ProposalTaskModelCopyWith<$Res>(_self.proposal, (value) {
    return _then(_self.copyWith(proposal: value));
  });
}
}

// dart format on
