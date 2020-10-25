import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/shared/models/task_model.dart';

class TaskCard extends StatelessWidget {

  final TaskModel task;
  final int index;

  const TaskCard({Key key, this.task, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      preferences: AnimationPreferences(
        offset: Duration(milliseconds: (index + 1) * 50)
      ),
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
                                  Text("Data de entrega:"),
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
    );
  }
}