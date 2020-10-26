import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/modules/task/task_bloc.dart';
import 'package:my_todos/app/shared/models/task_model.dart';
import 'package:my_todos/app/shared/widgets/dialog.dart';

class TaskCard extends StatelessWidget {

  final TaskModel task;
  final int index;
  static TaskBloc _taskBloc = Modular.get<TaskBloc>();

  const TaskCard({Key key, this.task, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      preferences: AnimationPreferences(
        offset: Duration(milliseconds: (index + 1) * 50)
      ),
      child: FocusedMenuHolder(
        onPressed: (){
          _taskBloc.showModalTask(task);
        },
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options
          FocusedMenuItem(
            title: Text("Visualizar"),
            trailingIcon: Icon(Ionicons.ios_eye),
            onPressed: (){
              _taskBloc.showModalTask(task);
            }
          ),
          FocusedMenuItem(
            title: Text("Editar"),
            trailingIcon: Icon(Icons.edit) ,
            onPressed: (){
              Get.toNamed('/tasks/register', arguments: task);
            }
          ),
          if(task.dataConclusao == null)
          FocusedMenuItem(
            title: Text("Concluir",style: TextStyle(color: Colors.green[400]),),
            trailingIcon: Icon(Icons.check_circle,color: Colors.green[400],) ,
            onPressed: ()async{
              if(await dialogConfirm('Concluir tarefa', 'Deseja realmente concluir essa tarefa?'))
              _taskBloc.concluirTask(task);
            }
          ),
          FocusedMenuItem(
            title: Text("Excluir",style: TextStyle(color: Colors.redAccent),),
            trailingIcon: Icon(Icons.delete,color: Colors.redAccent,),
            onPressed: ()async{
              if(await dialogConfirm('Excluir tarefa', 'Deseja realmente excluir essa tarefa?'))
              _taskBloc.excluirTask(task);
            }),
        ],
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: Container(
              height: 75,
              child: Row(
                children: [
                  Container(
                    height: 75,
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                      color: Get.theme.primaryColor
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        title: AutoSizeText(task.nome, maxLines: 2, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Data de entrega:"),
                                    Text(formatDate(task.dataEntrega, [dd, '/', mm, '/', yyyy,]))
                                  ],
                                ),
                              ),
                              if(task.dataConclusao != null)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Data de conclusão:"),
                                    Text(formatDate(task.dataConclusao, [dd, '/', mm, '/', yyyy,]))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Icon(
                          task.dataConclusao == null ? 
                          Icons.check_box_outline_blank
                          : Icons.check_box,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}