import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pyshop_test_task/common/texts.dart';
import 'package:pyshop_test_task/controllers/messaging_cubit.dart';
import 'package:pyshop_test_task/controllers/messaging_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyshop_test_task/services/services.dart';

class MessagingCubitImpl extends Cubit<MessagingState>
    implements MessagingCubit {

  MessagingCubitImpl(
      {required this.cameraService,
      required GeolocationService geolocationService,
      required NetworkService networkService})
      : _geolocationService = geolocationService,
        _networkService = networkService,
        textController = TextEditingController(),
        super(const MessagingState());

  @override
  final CameraService cameraService;
  @override
  final TextEditingController textController;
  final GeolocationService _geolocationService;
  final NetworkService _networkService;

  @override
  Future<void> initCamera() async {
    try {
      emit(state.copyWith(status: MessagingStatus.cameraInit));
      await cameraService.init();
      emit(state.copyWith(status: MessagingStatus.ready));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      emit(state.copyWith(
          status: MessagingStatus.error,
          errorText: ErrorTexts.initCameraErrorRu));
    }
  }

  @override
  Future<void> sendMessage() async {
    try {
      textController.clear();
      emit(state.copyWith(
          isTextFieldEmpty: true, status: MessagingStatus.sending));
      await _geolocationService.requestPermission();
      final coordinates = await _geolocationService.receiveCoordinates();
      final photo = await cameraService.takePhoto();
      await _networkService.sendPhoto(
          comment: textController.text,
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
          photoPath: photo.path);
      emit(state.copyWith(status: MessagingStatus.ready));
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      textController.clear();
      emit(state.copyWith(
          isTextFieldEmpty: true,
          status: MessagingStatus.error,
          errorText: ErrorTexts.sendMessageErrorRu));
    }
  }

  @override
  void updateFieldStatus(bool isEmpty) {
    emit(state.copyWith(isTextFieldEmpty: isEmpty));
  }

  @override
  Future<void> close() async {
    await cameraService.dispose();
    textController.dispose();
    return super.close();
  }
}
