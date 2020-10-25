import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/modules/task/pages/register_task.dart/register_task_dart_bloc.dart';
import 'package:my_todos/app/shared/models/task_model.dart';
import 'package:my_todos/app/shared/utils/enums.dart';
import 'package:my_todos/app/shared/widgets/screen_load.dart';

class RegisterTaskPage extends StatefulWidget {
  final String title;
  final TaskModel task;
  const RegisterTaskPage({Key key, this.title = "RegisterTask", this.task})
      : super(key: key);

  @override
  _RegisterTaskPageState createState() => _RegisterTaskPageState();
}

class _RegisterTaskPageState extends ModularState<RegisterTaskPage, RegisterTaskBloc> {

  @override
  void initState() {
    if(widget.task != null)
    controller.loadTaskEdit(widget.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PageStatus>(
      stream: controller.getStatus,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("ADICIONAR TAREFA", style: TextStyle(fontSize: 20),),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Nome", style: TextStyle(color: Colors.black38, fontSize: 17),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                initialValue: widget.task?.nome,
                                autovalidateMode: snapshot.data == PageStatus.error ? 
                                AutovalidateMode.always : null,
                                onChanged: (v) => controller.nome = v,
                                validator: (v) =>
                                v.isEmpty ? "Preencha o nome" :
                                null,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person, color: Colors.black26,),
                                  border: InputBorder.none,
                                  hintText: "Nome",
                                  hintStyle: TextStyle(color: Colors.black26)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text("Data de entrega", style: TextStyle(color: Colors.black38, fontSize: 17),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: TextFormField(
                                          onTap: () => controller.getDate(false),
                                          controller: controller.dataEntregaController,
                                          readOnly: true,
                                          autovalidateMode: snapshot.data == PageStatus.error ? 
                                          AutovalidateMode.always : null,
                                          onChanged: (v) => controller.nome = v,
                                          validator: (v) =>
                                          v.isEmpty ? "Preencha a data de entrega" :
                                          null,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.date_range_outlined, color: Colors.black26,),
                                            border: InputBorder.none,
                                            hintText: controller.formatDateBr(DateTime.now().add(Duration(days: 30))),
                                            hintStyle: TextStyle(color: Colors.black26)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text("Data de conclusão", style: TextStyle(color: Colors.black38, fontSize: 17),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: TextFormField(
                                          onTap: () => controller.getDate(true),
                                          readOnly: true,
                                          controller: controller.dataConclusaoController,
                                          autovalidateMode: snapshot.data == PageStatus.error ? 
                                          AutovalidateMode.always : null,
                                          onChanged: (v) => controller.nome = v,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person, color: Colors.black26,),
                                            border: InputBorder.none,
                                            hintText: controller.formatDateBr(DateTime.now().add(Duration(days: 30))),
                                            hintStyle: TextStyle(color: Colors.black26)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProgressButton(
                              color: Get.theme.primaryColor,
                              onPressed: () async {
                                Get.focusScope.unfocus();
                                if(widget.task != null)
                                await controller.updateTask(widget.task);
                                else
                                await controller.addTask();
                                return;
                              },
                              defaultWidget: Text("CONFIRMAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              progressWidget:  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if(snapshot.data == PageStatus.loading)
              ScreenLoad(message: controller.loadMessage,)
            ],
          ),
        );
      }
    );
  }
}
