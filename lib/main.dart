import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyshop_test_task/controllers/messaging_cubit.dart';
import 'package:pyshop_test_task/controllers/messaging_cubit_impl.dart';
import 'package:pyshop_test_task/pages/camera_page.dart';
import 'package:pyshop_test_task/services/camera_service_impl.dart';
import 'package:pyshop_test_task/services/geolocation_service_impl.dart';
import 'package:pyshop_test_task/services/network_service_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<MessagingCubit>(
          create: (context) => MessagingCubitImpl(
              cameraService: CameraServiceImpl(),
              geolocationService: GeolocationServiceImpl(),
              networkService: NetworkServiceImpl()),
          child: const CameraPage())
    );
  }
}