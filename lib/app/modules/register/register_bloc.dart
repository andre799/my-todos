import 'package:cep/cep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_todos/app/shared/blocs/auth_bloc.dart';
import 'package:my_todos/app/shared/models/user_model.dart';
import 'package:my_todos/app/shared/utils/enums.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Disposable {

  final AuthBloc _authBloc;

  RegisterBloc(this._authBloc);
  
  // Stream que controla o status da tela
  final _statusStream = BehaviorSubject<PageStatus>();
  Function(PageStatus) get setStatus => _statusStream.sink.add;
  Stream<PageStatus> get getStatus => _statusStream.stream;

  // Stream que controla o visibilidade da senha
  final _passwordVisibilityController = BehaviorSubject<bool>();
  Function(bool) get setVisibility => _passwordVisibilityController.sink.add;
  Stream<bool> get getVisibility => _passwordVisibilityController.stream;
  
  // Variaveis usadas para fazer o cadastro
  String nome, dataNascimento, cpf, cep, email, senha, endereco, numero = "";

  // Variáveis
  String messageLoading = "";

  // Controller do campo de endereço para autocomplete
  var enderecoController = TextEditingController();

  // Chave para validação do formulário
  final formKey = GlobalKey<FormState>();

  // Alterna a visibilidade do campo senha
  void get toogleVisibility
  => setVisibility(!(_passwordVisibilityController.value ?? true));

  // Máscaras 
  var dateMask = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  // Focos dos campos
  var nomeFocus = FocusNode();
  var dateFocus = FocusNode();
  var cpfFocus = FocusNode();
  var emailFocus = FocusNode();
  var senhaFocus = FocusNode();
  var cepFocus = FocusNode();
  var enderecoFocus = FocusNode();
  var numeroFocus = FocusNode();

  // Calcula a idade 
  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  // Busca o endereço de acordo com o CEP
  Future<void> searchAdressByCep(String cep) async {
    Get.focusScope.unfocus();
    messageLoading = "Buscando CEP";
    setStatus(PageStatus.loading);
    try{
      var consulta = await Cep.consultarCep(cep);
      if (consulta.logradouro != null) {
        var logradouro = consulta.logradouro;
        var bairro = consulta.bairro;
        var cidade = consulta.cidade;
        var uf = consulta.uf;
        enderecoController.text = "$logradouro, $bairro, $cidade-$uf";
        numeroFocus.requestFocus();
        setStatus(PageStatus.initial);
      } else {
        Get.rawSnackbar(message: "CEP não encontrado");
        setStatus(PageStatus.initial);
      }
      messageLoading = "";
    }catch(e){
      Get.rawSnackbar(message: "Erro ao buscar CEP, tente novamente.");
      setStatus(PageStatus.initial);
      messageLoading = "";
    }
  }

  // Função de conclusão do cadastro
  Future<void> register() async {
    if(formKey.currentState.validate()){
      messageLoading = "Criando usuário";
      setStatus(PageStatus.loading);
      var splitDate = dataNascimento.split('/');
      var birthDate = DateTime.parse("${splitDate.last}-${splitDate[1]}-${splitDate.first}");
      if(calculateAge(birthDate) < 12){
        setStatus(PageStatus.error);
        Get.dialog(
          AlertDialog(
            title: Text("Não foi possível finalizar seu cadastro."),
            content: Text("Para finalizar seu cadastro, é necessário atender alguns requisitos de idade."),
            actions: [
              FlatButton(
                onPressed: () => Get.back(),
                child: Text("ok")
              )
            ],
          )
        );
        return;
      }
      if(await _authBloc.userExists(email)){
        await Future.delayed(Duration(milliseconds: 500));
        Get.rawSnackbar(message: "Usuário já existente!");
        setStatus(PageStatus.initial);
        return;
      }
      var user = UserModel(
        birthdate: dataNascimento,
        cep: cep,
        cpf: cpf,
        email: email,
        endereco: endereco,
        nome: nome,
        numero: numero,
        password: senha
      );
      _authBloc.createUserAndLogin(user)
      .then((value) async {
        await Future.delayed(Duration(seconds: 2));
        Get.offAllNamed('/tasks');
      }).catchError((e){
        setStatus(PageStatus.initial);
        Get.rawSnackbar(message: "Erro ao criar usuário");
      });
    }else{
      setStatus(PageStatus.error);
    }
  }

  @override
  void dispose() {
    _statusStream.close();
    enderecoController.dispose();
    _passwordVisibilityController.close();
  }
}
