import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  @JsonValue('supervisor')
  supervisor,
  @JsonValue('worker')
  worker,
}

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String fullName,
    required UserRole role,
    String? avatarUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
