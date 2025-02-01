import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:adisyonapp/core/errors/failures.dart';

part 'ui_state.freezed.dart';

@freezed
class UiState<T> with _$UiState<T> {
  const factory UiState.initial() = _Initial<T>;
  const factory UiState.loading() = _Loading<T>;
  const factory UiState.success(T data) = _Success<T>;
  const factory UiState.error(Failure failure) = _Error<T>;
}

extension UiStateX<T> on UiState<T> {
  bool get isInitial => this is _Initial<T>;
  bool get isLoading => this is _Loading<T>;
  bool get isSuccess => this is _Success<T>;
  bool get isError => this is _Error<T>;

  T? get data => maybeWhen(
        success: (data) => data,
        orElse: () => null,
      );

  Failure? get error => maybeWhen(
        error: (failure) => failure,
        orElse: () => null,
      );
} 