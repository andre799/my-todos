import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_todos/app/shared/blocs/auth_bloc.dart';
import 'package:my_todos/app/shared/utils/enums.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Disposable {

  final AuthBloc _authBloc;

  LoginBloc(this._authBloc);

  // Stream que controla o status da tela
  final _statusStream = BehaviorSubject<PageStatus>();
  Function(PageStatus) get setStatus => _statusStream.sink.add;
  Stream<PageStatus> get getStatus => _statusStream.stream;

  // Stream que controla o visibilidade da senha
  final _passwordVisibilityController = BehaviorSubject<bool>();
  Function(bool) get setVisibility => _passwordVisibilityController.sink.add;
  Stream<bool> get getVisibility => _passwordVisibilityController.stream;
  
  // Variaveis usadas para fazer login
  var email = "";
  var senha = "";

  // Chave para validação do formulário
  final formKey = GlobalKey<FormState>();

  // Alterna a visibilidade do campo senha
  void get toogleVisibility
  => setVisibility(!(_passwordVisibilityController.value ?? true));


  // Focos dos campos
  var emailFocus = FocusNode();
  var senhaFocus = FocusNode();

  // Realiza login
  Future<void> login()
  => formKey.currentState.validate() ? _authBloc.login(email, senha) : null;

  @override
  void dispose() {
    _statusStream.close();
    _passwordVisibilityController.close();
  }
}
