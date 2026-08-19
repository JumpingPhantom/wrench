// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobChange {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobChange);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobChange()';
}


}

/// @nodoc
class $JobChangeCopyWith<$Res>  {
$JobChangeCopyWith(JobChange _, $Res Function(JobChange) __);
}


/// Adds pattern-matching-related methods to [JobChange].
extension JobChangePatterns on JobChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JobUpserted value)?  upserted,TResult Function( JobRemoved value)?  removed,TResult Function( JobsDesynced value)?  desynced,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JobUpserted() when upserted != null:
return upserted(_that);case JobRemoved() when removed != null:
return removed(_that);case JobsDesynced() when desynced != null:
return desynced(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JobUpserted value)  upserted,required TResult Function( JobRemoved value)  removed,required TResult Function( JobsDesynced value)  desynced,}){
final _that = this;
switch (_that) {
case JobUpserted():
return upserted(_that);case JobRemoved():
return removed(_that);case JobsDesynced():
return desynced(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JobUpserted value)?  upserted,TResult? Function( JobRemoved value)?  removed,TResult? Function( JobsDesynced value)?  desynced,}){
final _that = this;
switch (_that) {
case JobUpserted() when upserted != null:
return upserted(_that);case JobRemoved() when removed != null:
return removed(_that);case JobsDesynced() when desynced != null:
return desynced(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Job job)?  upserted,TResult Function( int id)?  removed,TResult Function()?  desynced,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JobUpserted() when upserted != null:
return upserted(_that.job);case JobRemoved() when removed != null:
return removed(_that.id);case JobsDesynced() when desynced != null:
return desynced();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Job job)  upserted,required TResult Function( int id)  removed,required TResult Function()  desynced,}) {final _that = this;
switch (_that) {
case JobUpserted():
return upserted(_that.job);case JobRemoved():
return removed(_that.id);case JobsDesynced():
return desynced();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Job job)?  upserted,TResult? Function( int id)?  removed,TResult? Function()?  desynced,}) {final _that = this;
switch (_that) {
case JobUpserted() when upserted != null:
return upserted(_that.job);case JobRemoved() when removed != null:
return removed(_that.id);case JobsDesynced() when desynced != null:
return desynced();case _:
  return null;

}
}

}

/// @nodoc


class JobUpserted implements JobChange {
  const JobUpserted(this.job);
  

 final  Job job;

/// Create a copy of JobChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobUpsertedCopyWith<JobUpserted> get copyWith => _$JobUpsertedCopyWithImpl<JobUpserted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobUpserted&&(identical(other.job, job) || other.job == job));
}


@override
int get hashCode => Object.hash(runtimeType,job);

@override
String toString() {
  return 'JobChange.upserted(job: $job)';
}


}

/// @nodoc
abstract mixin class $JobUpsertedCopyWith<$Res> implements $JobChangeCopyWith<$Res> {
  factory $JobUpsertedCopyWith(JobUpserted value, $Res Function(JobUpserted) _then) = _$JobUpsertedCopyWithImpl;
@useResult
$Res call({
 Job job
});


$JobCopyWith<$Res> get job;

}
/// @nodoc
class _$JobUpsertedCopyWithImpl<$Res>
    implements $JobUpsertedCopyWith<$Res> {
  _$JobUpsertedCopyWithImpl(this._self, this._then);

  final JobUpserted _self;
  final $Res Function(JobUpserted) _then;

/// Create a copy of JobChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? job = null,}) {
  return _then(JobUpserted(
null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as Job,
  ));
}

/// Create a copy of JobChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobCopyWith<$Res> get job {
  
  return $JobCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}

/// @nodoc


class JobRemoved implements JobChange {
  const JobRemoved(this.id);
  

 final  int id;

/// Create a copy of JobChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobRemovedCopyWith<JobRemoved> get copyWith => _$JobRemovedCopyWithImpl<JobRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'JobChange.removed(id: $id)';
}


}

/// @nodoc
abstract mixin class $JobRemovedCopyWith<$Res> implements $JobChangeCopyWith<$Res> {
  factory $JobRemovedCopyWith(JobRemoved value, $Res Function(JobRemoved) _then) = _$JobRemovedCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class _$JobRemovedCopyWithImpl<$Res>
    implements $JobRemovedCopyWith<$Res> {
  _$JobRemovedCopyWithImpl(this._self, this._then);

  final JobRemoved _self;
  final $Res Function(JobRemoved) _then;

/// Create a copy of JobChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(JobRemoved(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class JobsDesynced implements JobChange {
  const JobsDesynced();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobsDesynced);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobChange.desynced()';
}


}




// dart format on
