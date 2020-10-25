import 'package:my_todos/app/modules/login/login_module.dart';
import 'package:my_todos/app/modules/register/register_module.dart';
import 'package:my_todos/app/modules/splash/splash_module.dart';
import 'package:my_todos/app/modules/task/task_module.dart';
import 'package:my_todos/app/shared/blocs/auth_bloc.dart';
import 'package:my_todos/app/shared/repositories/auth_repository.dart';

import 'app_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:my_todos/app/app_widget.dart';

import 'shared/repositories/db_repository.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppBloc()),
        Bind((i) => DbRepository()),
        Bind((i) => AuthBloc(i())),
        Bind((i) => AuthRepository(i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/splash', module: SplashModule()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/register', module: RegisterModule()),
        ModularRouter('/tasks', module: TaskModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
