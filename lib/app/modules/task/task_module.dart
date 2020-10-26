import 'package:flutter_modular/flutter_modular.dart';

import 'pages/register_task/register_task_bloc.dart';
import 'pages/register_task/register_task_page.dart';
import 'repositories/task_repository.dart';
import 'task_bloc.dart';
import 'task_page.dart';

class TaskModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => RegisterTaskBloc(i(), i(), i())),
        Bind((i) => TaskBloc(i(), i())),
        Bind((i) => TaskRepository(i(), i()))
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => TaskPage()),
        ModularRouter('/register', child: (_, args) => RegisterTaskPage(task: args.data)),
      ];

  static Inject get to => Inject<TaskModule>.of();
}
