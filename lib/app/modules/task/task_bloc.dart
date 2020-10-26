import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/modules/task/repositories/task_repository.dart';
import 'package:my_todos/app/shared/blocs/auth_bloc.dart';
import 'package:my_todos/app/shared/models/task_model.dart';
import 'package:my_todos/app/shared/widgets/dialog.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc extends Disposable {
  
  final AuthBloc _authBloc;
  final TaskRepository _taskRepository;

  TaskBloc(this._authBloc, this._taskRepository){
    _taskRepository.getMyTasks()
    .then(setTasks);
  }

  //// Stream que controla a listagem de tarefas
  final _tasksController = BehaviorSubject<List<TaskModel>>();
  Function(List<TaskModel>) get setTasks => _tasksController.sink.add;
  Stream<List<TaskModel>> get getTasks => _tasksController.stream;

  // Função para adicionar tarefa a listagem de tarefas (Visualização)
  void addTask(TaskModel task){
    var tasks = _tasksController.value ?? List<TaskModel>();
    tasks.add(task);
    setTasks(tasks);
  }

  // Formatação de datq
  String formatDateBr(DateTime data){
    return formatDate(data, [dd, '/', mm, '/', yyyy,]);
  }

  // Mostra modal com as informações da tarefa
  Future<void> showModalTask(TaskModel task)async{
    return await Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                task.nome, 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Get.theme.primaryColor),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Data de entrega:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),),
                        Text(formatDateBr(task.dataEntrega), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Get.theme.primaryColor),),
                      ],
                    ),
                  ),
                  if(task.dataConclusao != null)
                  Expanded(
                    child: Column(
                      children: [
                        Text("Data de conclusão:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),),
                        Text(formatDateBr(task.dataConclusao), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Get.theme.primaryColor),),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              task.dataConclusao != null ? 
              Material(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 25,),
                      Text("TAREFA CONCLUÍDA", style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold),),
                      Icon(Icons.check_circle, color: Get.theme.primaryColor,)
                    ],
                  ),
                ),
              )
              : ProgressButton(
                color: Get.theme.primaryColor,
                onPressed: () async {
                  if(await dialogConfirm('Concluir tarefa', 'Deseja realmente concluir essa tarefa?')){
                    concluirTask(task);
                    Get.back();
                  }
                },
                defaultWidget: Text("CONCLUIR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                progressWidget:  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
              ),
            ],
          ),
        ),
      )
    );
  }

  // Atualiza a listagem de tarefas quando alguma edição for realizada
  void updateTask(TaskModel task){
    var tasks = _tasksController.value ?? List<TaskModel>();
    tasks.removeWhere((element) => element.id == task.id);
    tasks.add(task);
    tasks.sort((a,b) => a.id.compareTo(b.id));
    setTasks(tasks);
  }

  // Chama função de conclusão de tarefa e atualiza listagem das tarefas
  Future<void> concluirTask(TaskModel task) async {
    var taskUpdated = await _taskRepository.concluirTask(task);
    // Get.close(1);
    Get.rawSnackbar(message: "Tarefa concluída com sucesso!");
    updateTask(taskUpdated);
  }

  // Chama função de conclusão de tarefa e remove a tarefa excluída da listagem
  Future<void> excluirTask(TaskModel task) async {
    await _taskRepository.excluirTask(task);
    var tasks = _tasksController.value ?? List<TaskModel>();
    Get.rawSnackbar(message: "Tarefa excluída com sucesso!");
    tasks.removeWhere((element) => element.id == task.id);
    setTasks(tasks);
  }

  // Função para realizar logout
  void logout()
  => _authBloc.logout();

  @override
  void dispose() {
    _tasksController.close();
  }
}
