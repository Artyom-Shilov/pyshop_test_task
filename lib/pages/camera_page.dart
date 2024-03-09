import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyshop_test_task/common/texts.dart';
import 'package:pyshop_test_task/controllers/messaging_cubit.dart';
import 'package:pyshop_test_task/controllers/messaging_state.dart';
import 'package:pyshop_test_task/services/camera_service_impl.dart';
import 'package:pyshop_test_task/widgets/animated_send_button.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late MessagingCubit messagingCubit;

  @override
  void initState() {
    super.initState();
    messagingCubit = context.read<MessagingCubit>();
    messagingCubit.initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MessagingCubit, MessagingState>(
        listenWhen: (prev, next) => next.status == MessagingStatus.error,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Center(child: Text(state.errorText))));
        },
        buildWhen: (prev, next) => prev.status != next.status,
        builder: (context, state) {
          return state.status == MessagingStatus.cameraInit
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    children: [
                      SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                  width: 100,
                                  child: CameraPreview((messagingCubit
                                          .cameraService as CameraServiceImpl)
                                      .cameraController)))),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: constraints.maxHeight * 0.1),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth < 500
                                    ? constraints.maxWidth * 0.6
                                    : constraints.maxWidth * 0.4),
                            child: TextField(
                              controller: messagingCubit.textController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                  suffixIcon: const AnimatedSendButton(),
                                  filled: true,
                                  fillColor:
                                      CupertinoColors.white.withOpacity(0.2),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.7)),
                                  hintText: CameraPageTexts.inputFieldHintRu),
                              onTapOutside: (_) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              onChanged: (text) {
                                messagingCubit
                                    .updateFieldStatus(text.trim().isEmpty);
                              },
                            ),
                          ),
                        ),
                      ),
                      if (state.status == MessagingStatus.sending)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(CameraPageTexts.sendingMessageRu,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400
                              ),),
                              const SizedBox(
                                  width: 150,
                                  child: LinearProgressIndicator()),
                            ]
                          )
                        )
                    ]
                  )
                );
        }
      )
    );
  }
}