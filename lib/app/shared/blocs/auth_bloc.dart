import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/shared/models/user_model.dart';
import 'package:my_todos/app/shared/repositories/auth_repository.dart';

class AuthBloc extends Disposable{

  final AuthRepository authRepository;

  UserModel user;

  AuthBloc(this.authRepository);

  Future<void> createUserAndLogin(UserModel userModel)async{
    user = await authRepository.createUser(userModel);
  }

  Future<void> login(String email, String senha) async {
    user = await authRepository.getUser(email, senha);
    if(user != null)
    Get.offAllNamed('/tasks');
  }

  void logout(){
    user = null;
    Get.offAllNamed('/login');
  }

  @override
  void dispose() {
  }

}