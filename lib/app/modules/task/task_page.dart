import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_todos/app/modules/task/task_bloc.dart';
import 'package:my_todos/app/shared/models/task_model.dart';
import 'package:my_todos/app/shared/widgets/task_card.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key key,}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends ModularState<TaskPage, TaskBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TAREFAS", style: TextStyle(fontSize: 20),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white), 
            onPressed: controller.logout
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(MaterialCommunityIcons.playlist_plus, color: Colors.white,),
        onPressed: () => Get.toNamed('/tasks/register'),
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: controller.getTasks,
        builder: (context, snapshot) {
          if(snapshot.hasError)
          return Center(
            child: Text("Erro ao carregar tarefas."),
          );

          if(!snapshot.hasData)
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading.json',
              height: Get.mediaQuery.size.height / 3,
              repeat: true,
            ),
          ); 

          var tasks = snapshot.data;

          if(tasks.length == 0)
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  MaterialCommunityIcons.playlist_star,
                  size: Get.mediaQuery.size.height / 5,
                  color: Colors.black26
                ),
                Text(
                  "Nenhuma tarefa cadastrada", 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black26, fontSize: 18),
                ),
              ],
            ),
          );

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TaskCard(index: index, task: task,),
                  if(index == tasks.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                    child: Text("Segure em cima da tarefa para visualizar mais opções.", style: TextStyle(color: Colors.black38),),
                  )
                ],
              );

            },
          );
        }
      ),
    );
  }
}
