import 'package:freezed_annotation/freezed_annotation.dart';

part 'messaging_state.freezed.dart';

enum MessagingStatus {
  cameraInit,
  ready,
  sending,
  error
}

@freezed
class MessagingState with _$MessagingState {
  const factory MessagingState(
      {@Default(MessagingStatus.cameraInit) MessagingStatus status,
      @Default(true) isTextFieldEmpty,
      @Default('') String errorText}) = _MessagingState;
}
