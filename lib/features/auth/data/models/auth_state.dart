import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AppAuthState with _$AppAuthState {
  const factory AppAuthState.initial() = AuthInitial;
  const factory AppAuthState.loading() = AuthLoading;
  const factory AppAuthState.authenticated({required String userId}) =
      AuthAuthenticated;

  /// [offline] marks the failure as the phone's rather than the credentials',
  /// so the screen can say so in the user's own language instead of showing
  /// the transport's wording.
  const factory AppAuthState.error({
    required String message,
    @Default(false) bool offline,
  }) = AuthError;
}
