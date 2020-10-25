import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get/get.dart';
import 'package:my_todos/app/modules/login/login_bloc.dart';
import 'package:my_todos/app/shared/utils/enums.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginBloc> {
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PageStatus>(
      stream: controller.getStatus,
      initialData: PageStatus.initial,
      builder: (context, snapshot) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
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
                      child: Column(
                        children: [
                          SizedBox(height: 40,),
                          ZoomIn(
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: Get.mediaQuery.size.height / 5,
                            ),
                          ),
                        ],
                      )
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
                  padding: const EdgeInsets.all(8.0),
                  child: FadeInRight(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Bem-vindo(a) ao My Tasks!", style: TextStyle(color: Colors.black38, fontSize: 17),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                padding: const EdgeInsets.all(8.0),
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
                                padding: const EdgeInsets.all(8.0),
                                child: ProgressButton(
                                  color: Get.theme.primaryColor,
                                  onPressed: () async {
                                    Get.focusScope.unfocus();
                                    await controller.login();
                                    return;
                                  },
                                  defaultWidget: Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  progressWidget:  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                child: Container(
                                  width: double.infinity,
                                  child: OutlineButton(
                                    onPressed: () => Modular.to.pushNamed('/register'),
                                    borderSide: BorderSide(color: Get.theme.primaryColor, width: 1.5),
                                    child: Text("CADASTAR", style: TextStyle(color: Get.theme.primaryColor, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
