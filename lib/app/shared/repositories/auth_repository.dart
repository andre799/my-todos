import 'package:get/get.dart';
import 'package:my_todos/app/shared/models/user_model.dart';

import 'db_repository.dart';

class AuthRepository{

  final DbRepository dbRepository;

  AuthRepository(this.dbRepository);

  Future<UserModel> createUser(UserModel user) async {
    var id = await dbRepository.db.insert(dbRepository.userTable, user.toMap());
    user.id = id;
    return user;
  }

  Future<UserModel> getUser(String email, String senha) async {
    await Future.delayed(Duration(seconds: 1));

    final sql = '''SELECT * FROM ${dbRepository.userTable}
    WHERE email = ?''';

    List<dynamic> params = [email];

    final data = await dbRepository.db.rawQuery(sql, params);
    if(data.length == 0){
      Get.rawSnackbar(message: "Usuário não econtrado");
      return null;
    }

    if(UserModel.fromMap(data.first).password == senha){
      return UserModel.fromMap(data.first);
    }
    
    Get.rawSnackbar(message: "Senha incorreta, tente novamente.");

    return null;
  }

}