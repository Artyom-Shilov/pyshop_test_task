import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyshop_test_task/controllers/messaging_cubit.dart';
import 'package:pyshop_test_task/controllers/messaging_state.dart';

class AnimatedSendButton extends StatefulWidget {
  const AnimatedSendButton({Key? key}) : super(key: key);

  @override
  State<AnimatedSendButton> createState() => _AnimatedSendButtonState();
}

class _AnimatedSendButtonState extends State<AnimatedSendButton>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final MessagingCubit messagingCubit;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
        reverseDuration: const Duration(milliseconds: 300));
    messagingCubit = context.read<MessagingCubit>();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessagingCubit, MessagingState>(
        listenWhen: (prev, next) =>
            prev.isTextFieldEmpty != next.isTextFieldEmpty,
        listener: (context, state) => state.isTextFieldEmpty
            ? animationController.reverse()
            : animationController.forward(),
        buildWhen: (prev, next) =>
            prev.isTextFieldEmpty != next.isTextFieldEmpty,
        builder: (context, state) => AnimatedBuilder(
              animation: animationController,
            builder: (context, _) => Opacity(
                opacity: animationController.value,
                child: IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.send),
                  onPressed: !state.isTextFieldEmpty &&
                          state.status != MessagingStatus.sending
                      ? () async => messagingCubit.sendMessage()
                      : null,
                ))));
  }
}
