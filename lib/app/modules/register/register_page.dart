import 'package:brasil_fields/brasil_fields.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/modules/register/register_bloc.dart';
import 'package:my_todos/app/shared/utils/enums.dart';
import 'package:my_todos/app/shared/widgets/screen_load.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key key, this.title = "Register"}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ModularState<RegisterPage, RegisterBloc> {
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PageStatus>(
      stream: controller.getStatus,
      initialData: PageStatus.initial,
      builder: (context, snapshot) {
        return Scaffold(
          // resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.grey[300],
          body: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(55, 25), bottomRight: Radius.elliptical(55, 25))
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SafeArea(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        height: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Form(
                            key: controller.formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.arrow_back_ios, color: Colors.black38,),
                                        onPressed: () => Get.back(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("Cadastro", style: TextStyle(color: Colors.black38, fontSize: 17),),
                                      ),
                                      SizedBox(width: 50,)
                                    ],
                                  ),
                                  SizedBox(height: 20,),
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
                                          focusNode: controller.nomeFocus,
                                          autovalidateMode: snapshot.data == PageStatus.error ? 
                                          AutovalidateMode.always : null,
                                          onChanged: (v) => controller.nome = v,
                                          onEditingComplete: () => controller.dateFocus.requestFocus(),
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

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text("Data de nascimento", style: TextStyle(color: Colors.black38, fontSize: 17)),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text("CPF", style: TextStyle(color: Colors.black38, fontSize: 17)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.grey[200],
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: TextFormField(
                                                focusNode: controller.dateFocus,
                                                autovalidateMode: snapshot.data == PageStatus.error ? 
                                                AutovalidateMode.always : null,
                                                onChanged: (v) => controller.dataNascimento = v,
                                                onEditingComplete: () => controller.cpfFocus.requestFocus(),
                                                keyboardType: TextInputType.number,
                                                validator: (v) =>
                                                v.isEmpty ? "Preencha a data de nascimento" :
                                                v.length < 10 ? "Data de nascimento inválida" : null,
                                                inputFormatters: [
                                                  controller.dateMask
                                                ],
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(Icons.date_range, color: Colors.black26,),
                                                  border: InputBorder.none,
                                                  hintText: "01/01/1990",
                                                  hintStyle: TextStyle(color: Colors.black26)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.grey[200],
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: TextFormField(
                                                focusNode: controller.cpfFocus,
                                                autovalidateMode: snapshot.data == PageStatus.error ? 
                                                AutovalidateMode.always : null,
                                                onChanged: (v) => controller.cpf = v,
                                                onEditingComplete: () => controller.cepFocus.requestFocus(),
                                                keyboardType: TextInputType.number,
                                                validator: (v) =>
                                                v.isEmpty ? null :
                                                !CPFValidator.isValid(v) ? 
                                                "Digite um CPF válido":
                                                null,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                  CpfInputFormatter()
                                                ],
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(AntDesign.idcard, color: Colors.black26,),
                                                  border: InputBorder.none,
                                                  hintText: "CPF",
                                                  hintStyle: TextStyle(color: Colors.black26)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Center(
                                    child: Text("CEP", style: TextStyle(color: Colors.black38, fontSize: 17)),
                                  ),
                                  Center(
                                    child: Container(
                                      width: Get.mediaQuery.size.width / 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.grey[200],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: TextFormField(
                                              focusNode: controller.cepFocus,
                                              onChanged: (v) {
                                                controller.cep = v;
                                                if(v.length == 8)
                                                controller.searchAdressByCep(v);
                                              },
                                              onEditingComplete: () => controller.enderecoFocus.requestFocus(),
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Entypo.address, color: Colors.black26,),
                                                border: InputBorder.none,
                                                hintText: "CEP",
                                                hintStyle: TextStyle(color: Colors.black26)
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Endereço", style: TextStyle(color: Colors.black38, fontSize: 17)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: TextFormField(
                                          focusNode: controller.enderecoFocus,
                                          controller: controller.enderecoController,
                                          onChanged: (v) => controller.endereco = v,
                                          onEditingComplete: () => controller.numeroFocus.requestFocus(),
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.home, color: Colors.black26,),
                                            border: InputBorder.none,
                                            hintText: "Endereço",
                                            hintStyle: TextStyle(color: Colors.black26)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  Center(
                                    child: Text("Número", style: TextStyle(color: Colors.black38, fontSize: 17)),
                                  ),
                                  Center(
                                    child: Container(
                                      width: Get.mediaQuery.size.width / 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.grey[200],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: TextFormField(
                                              focusNode: controller.numeroFocus,
                                              onChanged: (v) => controller.numero = v,
                                              onEditingComplete: () => controller.emailFocus.requestFocus(),
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Entypo.location_pin, color: Colors.black26,),
                                                border: InputBorder.none,
                                                hintText: "123",
                                                hintStyle: TextStyle(color: Colors.black26)
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Email", style: TextStyle(color: Colors.black38, fontSize: 17)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: TextFormField(
                                          focusNode: controller.emailFocus,
                                          autovalidateMode: snapshot.data == PageStatus.error ? 
                                          AutovalidateMode.always : null,
                                          onChanged: (v) => controller.email = v,
                                          onEditingComplete: () => controller.senhaFocus.requestFocus(),
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (v) =>
                                          v.isEmpty ? "Preencha o email" : 
                                          !EmailValidator.validate(v) ? "Digite um email válido" :
                                          null,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email, color: Colors.black26,),
                                            border: InputBorder.none,
                                            hintText: "Email",
                                            hintStyle: TextStyle(color: Colors.black26)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Senha", style: TextStyle(color: Colors.black38, fontSize: 17)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: StreamBuilder<bool>(
                                          stream: controller.getVisibility,
                                          initialData: true,
                                          builder: (context, snapshotv) {
                                            return TextFormField(
                                              focusNode: controller.senhaFocus,
                                              autovalidateMode: snapshot.data == PageStatus.error ? 
                                              AutovalidateMode.always : null,
                                              onChanged: (v) => controller.senha = v,
                                              onEditingComplete: () => Get.focusScope.unfocus(),  
                                              obscureText: snapshotv.data,
                                              validator: (v) => 
                                              v.isEmpty ? "Digite a senha" : null,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.lock, color: Colors.black26,),
                                                suffixIcon: InkWell(
                                                  onTap: () => controller.toogleVisibility,
                                                  child: Icon(!snapshotv.data ? Icons.visibility_off : Icons.visibility, color: Colors.black26,),
                                                ),
                                                border: InputBorder.none,
                                                hintText: "Senha",
                                                hintStyle: TextStyle(color: Colors.black26)
                                              ),
                                            );
                                          }
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ProgressButton(
                                      color: Get.theme.primaryColor,
                                      onPressed: () async {
                                        await controller.register();
                                      },
                                      defaultWidget: Text("CONFIRMAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                      progressWidget:  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if(snapshot.data == PageStatus.loading)
              ScreenLoad(message: controller.messageLoading,)
            ],
          ),
        );
      }
    );
  }
}
