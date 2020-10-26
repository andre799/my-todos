import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/shared/models/user_model.dart';
import 'package:my_todos/app/shared/repositories/auth_repository.dart';

class AuthBloc extends Disposable{

  final AuthRepository authRepository;

  // Usuário logado no app
  UserModel user;

  AuthBloc(this.authRepository);

  // Função para criar usuário
  Future<void> createUserAndLogin(UserModel userModel)async{
    user = await authRepository.createUser(userModel);
  }

  // Função para realizar login
  Future<void> login(String email, String senha) async {
    user = await authRepository.getUser(email, senha);
    if(user != null)
    Get.offAllNamed('/tasks');
  }

  // Função que verifica se o usuário já existe
  Future<bool> userExists(String email)
  async => authRepository.userExists(email);

  // Função para fazer logout do app
  void logout(){
    user = null;
    Get.offAllNamed('/login');
  }

  @override
  void dispose() {
  }

}