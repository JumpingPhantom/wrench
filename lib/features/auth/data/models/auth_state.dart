import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AppAuthState with _$AppAuthState {
  const factory AppAuthState.initial() = AuthInitial;
  const factory AppAuthState.loading() = AuthLoading;
  const factory AppAuthState.authenticated({required String userId}) =
      AuthAuthenticated;
  const factory AppAuthState.error({required String message}) = AuthError;
}
