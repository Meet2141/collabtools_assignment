import 'package:collabtools_assignment/core/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/database/hive_service.dart';
import 'logic/bloc/todo_bloc.dart';
import 'logic/bloc/todo_event.dart';
import 'logic/network/bloc/network_bloc.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService.initHive();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc()..add(LoadTasksEvent())),
        BlocProvider(create: (context) => NetworkStatusBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstants.appName,
        home: HomeScreen(),
      ),
    );
  }
}
