import 'package:flutter_modular/flutter_modular.dart';

import 'login_bloc.dart';
import 'login_page.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginBloc(i())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => LoginPage(), transition: TransitionType.fadeIn, duration: Duration(milliseconds: 800)),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
