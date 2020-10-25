import 'package:date_format/date_format.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_todos/app/modules/task/repositories/task_repository.dart';
import 'package:my_todos/app/shared/blocs/auth_bloc.dart';
import 'package:my_todos/app/shared/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc extends Disposable {
  
  final AuthBloc _authBloc;
  final TaskRepository _taskRepository;

  final _tasksController = BehaviorSubject<List<TaskModel>>();
  Function(List<TaskModel>) get setTasks => _tasksController.sink.add;
  Stream<List<TaskModel>> get getTasks => _tasksController.stream;

  void addTask(TaskModel task){
    var tasks = _tasksController.value ?? List<TaskModel>();
    tasks.add(task);
    setTasks(tasks);
  }

  String formatDateBr(DateTime data){
    return formatDate(data, [dd, '/', mm, '/', yyyy,]);
  }

  void updateTask(TaskModel task){
    var tasks = _tasksController.value ?? List<TaskModel>();
    tasks.removeWhere((element) => element.id == task.id);
    tasks.add(task);
    tasks.sort((a,b) => a.id.compareTo(b.id));
    setTasks(tasks);
  }

  TaskBloc(this._authBloc, this._taskRepository){
    _taskRepository.getMyTasks()
    .then(setTasks);
  }

  void logout()
  => _authBloc.logout();

  @override
  void dispose() {
    _tasksController.close();
  }
}
