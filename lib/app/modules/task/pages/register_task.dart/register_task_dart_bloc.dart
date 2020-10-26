import 'package:date_format/date_format.dart' hide Locale;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/modules/task/repositories/task_repository.dart';
import 'package:my_todos/app/modules/task/task_bloc.dart';
import 'package:my_todos/app/shared/blocs/auth_bloc.dart';
import 'package:my_todos/app/shared/models/task_model.dart';
import 'package:my_todos/app/shared/utils/enums.dart';
import 'package:rxdart/rxdart.dart';

class RegisterTaskBloc extends Disposable {
  
  final TaskRepository _taskRepository;
  final TaskBloc _taskBloc;
  final AuthBloc _authBloc;

  RegisterTaskBloc(this._taskRepository, this._taskBloc, this._authBloc);

  // Variáveis usadas para criar / editar tarefa
  DateTime dataConclusao;
  DateTime dataEntrega;
  String nome;

  // Controller dos campos para preenchimento
  var dataConclusaoController = TextEditingController();
  var dataEntregaController = TextEditingController();

  // Variáveis
  String loadMessage;
  final formKey = GlobalKey<FormState>();

  // Stream que controla o status da tela
  final _statusStream = BehaviorSubject<PageStatus>();
  Function(PageStatus) get setStatus => _statusStream.sink.add;
  Stream<PageStatus> get getStatus => _statusStream.stream;

  // Função para formatar data
  String formatDateBr(DateTime data){
    return formatDate(data, [dd, '/', mm, '/', yyyy,]);
  }

  // Função para chamar o datePicker
  Future<void> getDate(bool conclusao) async {
    var date = await showDatePicker(
      locale: Locale('pt', 'BR'),
      context: Get.context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(DateTime.now().year - 4),
      lastDate: DateTime(DateTime.now().year + 4),
    );

    if(date == null) return;

    if(conclusao){
      dataConclusao = date;
      dataConclusaoController.text = formatDateBr(date);
    }else{
      dataEntrega = date;
      dataEntregaController.text = formatDateBr(date);
    }
    
  }

  // Carrega as variáveis com as informações da tarefa caso se trate de uma edição
  void loadTaskEdit(TaskModel task){
    dataConclusao = task.dataConclusao;
    if(task.dataConclusao != null)
    dataConclusaoController.text = formatDateBr(task.dataConclusao);
    dataEntrega = task.dataEntrega;
    dataEntregaController.text = formatDateBr(task.dataEntrega);
    nome = task.nome;
  }

  // Função para arualizar a tarefa selecionada para edição
  Future<void> updateTask(TaskModel task)async{

    await Future.delayed(Duration(milliseconds: 500));

    if(!formKey.currentState.validate()) return;

    task.dataConclusao = dataConclusao;
    task.dataEntrega = dataEntrega;
    task.nome = nome;

    await _taskRepository.updateTask(task);

    Get.back();

    Get.rawSnackbar(message: "Tarefa editada com sucesso!");

    _taskBloc.updateTask(task);
  }

  // Função para adicionar tarefa
  Future<void> addTask()async{

    await Future.delayed(Duration(milliseconds: 500));

    if(!formKey.currentState.validate()) return;

    var task = TaskModel(
      dataConclusao: dataConclusao,
      dataEntrega: dataEntrega,
      nome: nome,
      userId: _authBloc.user.id
    );

    task = await _taskRepository.addTask(task);

    Get.back();

    Get.rawSnackbar(message: "Tarefa adicionada com sucesso!");

    _taskBloc.addTask(task);

  }

  @override
  void dispose() {
    _statusStream.close();
  }
}
