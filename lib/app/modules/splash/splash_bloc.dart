import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_todos/app/shared/repositories/db_repository.dart';

class SplashBloc extends Disposable {

  final DbRepository dbRepository;

  SplashBloc(this.dbRepository);

  @override
  void dispose() {}
}
