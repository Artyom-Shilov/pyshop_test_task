import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyshop_test_task/controllers/messaging_state.dart';
import 'package:pyshop_test_task/services/camera_service.dart';

abstract interface class MessagingCubit extends Cubit<MessagingState> {
  MessagingCubit(super.initialState);

  Future<void> initCamera();
  Future<void> sendMessage();

  void updateFieldStatus(bool isEmpty);

  CameraService get cameraService;
  TextEditingController get textController;
}