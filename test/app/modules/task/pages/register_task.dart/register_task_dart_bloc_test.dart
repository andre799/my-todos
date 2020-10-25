import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_todos/app/app_module.dart';
import 'package:my_todos/app/modules/task/pages/register_task.dart/register_task_dart_bloc.dart';
import 'package:my_todos/app/modules/task/task_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(TaskModule());
  RegisterTaskBloc bloc;

  // setUp(() {
  //     bloc = TaskModule.to.get<RegisterTaskBloc>();
  // });

  // group('RegisterTaskBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<RegisterTaskBloc>());
  //   });
  // });
}
