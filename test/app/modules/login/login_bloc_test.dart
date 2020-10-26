import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_todos/app/app_module.dart';
import 'package:my_todos/app/modules/login/login_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(LoginModule());
  // LoginBloc bloc;

  // setUp(() {
  //     bloc = LoginModule.to.get<LoginBloc>();
  // });

  // group('LoginBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<LoginBloc>());
  //   });
  // });
}
