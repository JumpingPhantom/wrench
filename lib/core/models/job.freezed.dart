// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Job {

 String get id; String get title; String get description; String get location; DateTime get createdAt; String get createdBy; JobState get state; String? get mediaUrl;
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobCopyWith<Job> get copyWith => _$JobCopyWithImpl<Job>(this as Job, _$identity);

  /// Serializes this Job to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Job&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.state, state) || other.state == state)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,location,createdAt,createdBy,state,mediaUrl);

@override
String toString() {
  return 'Job(id: $id, title: $title, description: $description, location: $location, createdAt: $createdAt, createdBy: $createdBy, state: $state, mediaUrl: $mediaUrl)';
}


}

/// @nodoc
abstract mixin class $JobCopyWith<$Res>  {
  factory $JobCopyWith(Job value, $Res Function(Job) _then) = _$JobCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String location, DateTime createdAt, String createdBy, JobState state, String? mediaUrl
});


$JobStateCopyWith<$Res> get state;

}
/// @nodoc
class _$JobCopyWithImpl<$Res>
    implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._self, this._then);

  final Job _self;
  final $Res Function(Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? location = null,Object? createdAt = null,Object? createdBy = null,Object? state = null,Object? mediaUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as JobState,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobStateCopyWith<$Res> get state {

  return $JobStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
}
}


/// Adds pattern-matching-related methods to [Job].
extension JobPatterns on Job {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Job value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Job value)  $default,){
final _that = this;
switch (_that) {
case _Job():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Job value)?  $default,){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String location,  DateTime createdAt,  String createdBy,  JobState state,  String? mediaUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.location,_that.createdAt,_that.createdBy,_that.state,_that.mediaUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String location,  DateTime createdAt,  String createdBy,  JobState state,  String? mediaUrl)  $default,) {final _that = this;
switch (_that) {
case _Job():
return $default(_that.id,_that.title,_that.description,_that.location,_that.createdAt,_that.createdBy,_that.state,_that.mediaUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String location,  DateTime createdAt,  String createdBy,  JobState state,  String? mediaUrl)?  $default,) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.location,_that.createdAt,_that.createdBy,_that.state,_that.mediaUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Job extends Job {
  _Job({required this.id, required this.title, required this.description, required this.location, required this.createdAt, required this.createdBy, required this.state, this.mediaUrl}): super._();
  factory _Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String location;
@override final  DateTime createdAt;
@override final  String createdBy;
@override final  JobState state;
@override final  String? mediaUrl;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobCopyWith<_Job> get copyWith => __$JobCopyWithImpl<_Job>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Job&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.state, state) || other.state == state)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,location,createdAt,createdBy,state,mediaUrl);

@override
String toString() {
  return 'Job(id: $id, title: $title, description: $description, location: $location, createdAt: $createdAt, createdBy: $createdBy, state: $state, mediaUrl: $mediaUrl)';
}


}

/// @nodoc
abstract mixin class _$JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$JobCopyWith(_Job value, $Res Function(_Job) _then) = __$JobCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String location, DateTime createdAt, String createdBy, JobState state, String? mediaUrl
});


@override $JobStateCopyWith<$Res> get state;

}
/// @nodoc
class __$JobCopyWithImpl<$Res>
    implements _$JobCopyWith<$Res> {
  __$JobCopyWithImpl(this._self, this._then);

  final _Job _self;
  final $Res Function(_Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? location = null,Object? createdAt = null,Object? createdBy = null,Object? state = null,Object? mediaUrl = freezed,}) {
  return _then(_Job(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as JobState,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobStateCopyWith<$Res> get state {

  return $JobStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
}
}

JobState _$JobStateFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'draft':
          return _Draft.fromJson(
            json
          );
                case 'inProgress':
          return _InProgress.fromJson(
            json
          );
                case 'staged':
          return _Staged.fromJson(
            json
          );
                case 'finished':
          return _Finished.fromJson(
            json
          );
                case 'cancelled':
          return _Cancelled.fromJson(
            json
          );

          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'JobState',
  'Invalid union type "${json['runtimeType']}"!'
);
        }

}

/// @nodoc
mixin _$JobState {



  /// Serializes this JobState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobState);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobState()';
}


}

/// @nodoc
class $JobStateCopyWith<$Res>  {
$JobStateCopyWith(JobState _, $Res Function(JobState) __);
}


/// Adds pattern-matching-related methods to [JobState].
extension JobStatePatterns on JobState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Draft value)?  draft,TResult Function( _InProgress value)?  inProgress,TResult Function( _Staged value)?  staged,TResult Function( _Finished value)?  finished,TResult Function( _Cancelled value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Draft() when draft != null:
return draft(_that);case _InProgress() when inProgress != null:
return inProgress(_that);case _Staged() when staged != null:
return staged(_that);case _Finished() when finished != null:
return finished(_that);case _Cancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Draft value)  draft,required TResult Function( _InProgress value)  inProgress,required TResult Function( _Staged value)  staged,required TResult Function( _Finished value)  finished,required TResult Function( _Cancelled value)  cancelled,}){
final _that = this;
switch (_that) {
case _Draft():
return draft(_that);case _InProgress():
return inProgress(_that);case _Staged():
return staged(_that);case _Finished():
return finished(_that);case _Cancelled():
return cancelled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Draft value)?  draft,TResult? Function( _InProgress value)?  inProgress,TResult? Function( _Staged value)?  staged,TResult? Function( _Finished value)?  finished,TResult? Function( _Cancelled value)?  cancelled,}){
final _that = this;
switch (_that) {
case _Draft() when draft != null:
return draft(_that);case _InProgress() when inProgress != null:
return inProgress(_that);case _Staged() when staged != null:
return staged(_that);case _Finished() when finished != null:
return finished(_that);case _Cancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  draft,TResult Function( String startedBy,  DateTime startedAt,  List<String>? workers)?  inProgress,TResult Function( DateTime stagedAt)?  staged,TResult Function( String approvedBy,  DateTime finishedAt)?  finished,TResult Function( String reason,  DateTime cancelledAt,  String cancelledBy)?  cancelled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Draft() when draft != null:
return draft();case _InProgress() when inProgress != null:
return inProgress(_that.startedBy,_that.startedAt,_that.workers);case _Staged() when staged != null:
return staged(_that.stagedAt);case _Finished() when finished != null:
return finished(_that.approvedBy,_that.finishedAt);case _Cancelled() when cancelled != null:
return cancelled(_that.reason,_that.cancelledAt,_that.cancelledBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  draft,required TResult Function( String startedBy,  DateTime startedAt,  List<String>? workers)  inProgress,required TResult Function( DateTime stagedAt)  staged,required TResult Function( String approvedBy,  DateTime finishedAt)  finished,required TResult Function( String reason,  DateTime cancelledAt,  String cancelledBy)  cancelled,}) {final _that = this;
switch (_that) {
case _Draft():
return draft();case _InProgress():
return inProgress(_that.startedBy,_that.startedAt,_that.workers);case _Staged():
return staged(_that.stagedAt);case _Finished():
return finished(_that.approvedBy,_that.finishedAt);case _Cancelled():
return cancelled(_that.reason,_that.cancelledAt,_that.cancelledBy);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  draft,TResult? Function( String startedBy,  DateTime startedAt,  List<String>? workers)?  inProgress,TResult? Function( DateTime stagedAt)?  staged,TResult? Function( String approvedBy,  DateTime finishedAt)?  finished,TResult? Function( String reason,  DateTime cancelledAt,  String cancelledBy)?  cancelled,}) {final _that = this;
switch (_that) {
case _Draft() when draft != null:
return draft();case _InProgress() when inProgress != null:
return inProgress(_that.startedBy,_that.startedAt,_that.workers);case _Staged() when staged != null:
return staged(_that.stagedAt);case _Finished() when finished != null:
return finished(_that.approvedBy,_that.finishedAt);case _Cancelled() when cancelled != null:
return cancelled(_that.reason,_that.cancelledAt,_that.cancelledBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Draft implements JobState {
  const _Draft({final  String? $type}): $type = $type ?? 'draft';
  factory _Draft.fromJson(Map<String, dynamic> json) => _$DraftFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$DraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Draft);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobState.draft()';
}


}




/// @nodoc
@JsonSerializable()

class _InProgress implements JobState {
  const _InProgress({required this.startedBy, required this.startedAt, final  List<String>? workers, final  String? $type}): _workers = workers,$type = $type ?? 'inProgress';
  factory _InProgress.fromJson(Map<String, dynamic> json) => _$InProgressFromJson(json);

 final  String startedBy;
 final  DateTime startedAt;
 final  List<String>? _workers;
 List<String>? get workers {
  final value = _workers;
  if (value == null) return null;
  if (_workers is EqualUnmodifiableListView) return _workers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InProgressCopyWith<_InProgress> get copyWith => __$InProgressCopyWithImpl<_InProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InProgress&&(identical(other.startedBy, startedBy) || other.startedBy == startedBy)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&const DeepCollectionEquality().equals(other._workers, _workers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedBy,startedAt,const DeepCollectionEquality().hash(_workers));

@override
String toString() {
  return 'JobState.inProgress(startedBy: $startedBy, startedAt: $startedAt, workers: $workers)';
}


}

/// @nodoc
abstract mixin class _$InProgressCopyWith<$Res> implements $JobStateCopyWith<$Res> {
  factory _$InProgressCopyWith(_InProgress value, $Res Function(_InProgress) _then) = __$InProgressCopyWithImpl;
@useResult
$Res call({
 String startedBy, DateTime startedAt, List<String>? workers
});




}
/// @nodoc
class __$InProgressCopyWithImpl<$Res>
    implements _$InProgressCopyWith<$Res> {
  __$InProgressCopyWithImpl(this._self, this._then);

  final _InProgress _self;
  final $Res Function(_InProgress) _then;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? startedBy = null,Object? startedAt = null,Object? workers = freezed,}) {
  return _then(_InProgress(
startedBy: null == startedBy ? _self.startedBy : startedBy // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,workers: freezed == workers ? _self._workers : workers // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _Staged implements JobState {
  const _Staged({required this.stagedAt, final  String? $type}): $type = $type ?? 'staged';
  factory _Staged.fromJson(Map<String, dynamic> json) => _$StagedFromJson(json);

 final  DateTime stagedAt;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StagedCopyWith<_Staged> get copyWith => __$StagedCopyWithImpl<_Staged>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StagedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Staged&&(identical(other.stagedAt, stagedAt) || other.stagedAt == stagedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stagedAt);

@override
String toString() {
  return 'JobState.staged(stagedAt: $stagedAt)';
}


}

/// @nodoc
abstract mixin class _$StagedCopyWith<$Res> implements $JobStateCopyWith<$Res> {
  factory _$StagedCopyWith(_Staged value, $Res Function(_Staged) _then) = __$StagedCopyWithImpl;
@useResult
$Res call({
 DateTime stagedAt
});




}
/// @nodoc
class __$StagedCopyWithImpl<$Res>
    implements _$StagedCopyWith<$Res> {
  __$StagedCopyWithImpl(this._self, this._then);

  final _Staged _self;
  final $Res Function(_Staged) _then;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stagedAt = null,}) {
  return _then(_Staged(
stagedAt: null == stagedAt ? _self.stagedAt : stagedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _Finished implements JobState {
  const _Finished({required this.approvedBy, required this.finishedAt, final  String? $type}): $type = $type ?? 'finished';
  factory _Finished.fromJson(Map<String, dynamic> json) => _$FinishedFromJson(json);

 final  String approvedBy;
 final  DateTime finishedAt;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishedCopyWith<_Finished> get copyWith => __$FinishedCopyWithImpl<_Finished>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Finished&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,approvedBy,finishedAt);

@override
String toString() {
  return 'JobState.finished(approvedBy: $approvedBy, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$FinishedCopyWith<$Res> implements $JobStateCopyWith<$Res> {
  factory _$FinishedCopyWith(_Finished value, $Res Function(_Finished) _then) = __$FinishedCopyWithImpl;
@useResult
$Res call({
 String approvedBy, DateTime finishedAt
});




}
/// @nodoc
class __$FinishedCopyWithImpl<$Res>
    implements _$FinishedCopyWith<$Res> {
  __$FinishedCopyWithImpl(this._self, this._then);

  final _Finished _self;
  final $Res Function(_Finished) _then;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? approvedBy = null,Object? finishedAt = null,}) {
  return _then(_Finished(
approvedBy: null == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _Cancelled implements JobState {
  const _Cancelled({required this.reason, required this.cancelledAt, required this.cancelledBy, final  String? $type}): $type = $type ?? 'cancelled';
  factory _Cancelled.fromJson(Map<String, dynamic> json) => _$CancelledFromJson(json);

 final  String reason;
 final  DateTime cancelledAt;
 final  String cancelledBy;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CancelledCopyWith<_Cancelled> get copyWith => __$CancelledCopyWithImpl<_Cancelled>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CancelledToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cancelled&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason,cancelledAt,cancelledBy);

@override
String toString() {
  return 'JobState.cancelled(reason: $reason, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy)';
}


}

/// @nodoc
abstract mixin class _$CancelledCopyWith<$Res> implements $JobStateCopyWith<$Res> {
  factory _$CancelledCopyWith(_Cancelled value, $Res Function(_Cancelled) _then) = __$CancelledCopyWithImpl;
@useResult
$Res call({
 String reason, DateTime cancelledAt, String cancelledBy
});




}
/// @nodoc
class __$CancelledCopyWithImpl<$Res>
    implements _$CancelledCopyWith<$Res> {
  __$CancelledCopyWithImpl(this._self, this._then);

  final _Cancelled _self;
  final $Res Function(_Cancelled) _then;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? cancelledAt = null,Object? cancelledBy = null,}) {
  return _then(_Cancelled(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,cancelledAt: null == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime,cancelledBy: null == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
