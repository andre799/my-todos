import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_todos/app/shared/blocs/auth_bloc.dart';
import 'package:my_todos/app/shared/models/task_model.dart';
import 'package:my_todos/app/shared/repositories/db_repository.dart';

@Injectable()
class TaskRepository extends Disposable {

  final DbRepository _dbRepository;
  final AuthBloc _authBloc;

  TaskRepository(this._dbRepository, this._authBloc);

  Future<List<TaskModel>> getMyTasks()async{
    final sql = '''SELECT * FROM ${_dbRepository.tasksTable}
    WHERE userId = ?''';

    List<dynamic> params = [_authBloc.user.id];

    final data = await _dbRepository.db.rawQuery(sql, params);

    return data.map((e) => TaskModel.fromMap(e)).toList();

  }

  Future<TaskModel> addTask(TaskModel task) async {
    var id = await _dbRepository.db.insert(_dbRepository.tasksTable, task.toMap());
    task.id = id;
    return task;
  }
  
  Future<TaskModel> updateTask(TaskModel task)async{
     await _dbRepository.db.update(_dbRepository.tasksTable, task.toMap(updating: true), where: "id = ?", whereArgs: [task.id]);
     return task;
  }

  @override
  void dispose() {}
}
