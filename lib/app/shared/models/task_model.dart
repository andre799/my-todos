class TaskModel {

  int id;
  int userId;
  String nome;
  DateTime dataEntrega;
  DateTime dataConclusao;

  TaskModel({
    this.id,
    this.userId,
    this.nome,
    this.dataEntrega,
    this.dataConclusao,
  });

  Map<String, dynamic> toMap({bool updating = false}) {
    var map = {
      'userId': userId,
      'nome': nome,
      'dataEntrega': dataEntrega?.toString(),
      'dataConclusao': dataConclusao?.toString(),
    };
    if(!updating)
    map['id'] = id;
    return map;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TaskModel(
      id: map['id'],
      userId: map['userId'],
      nome: map['nome'],
      dataEntrega: DateTime.parse(map['dataEntrega']),
      dataConclusao: map['dataConclusao'] != null ? DateTime.parse(map['dataConclusao']) : null,
    );
  }
}
