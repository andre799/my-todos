class UserModel {

  int id;
  String nome;
  String birthdate;
  String cpf;
  String cep;
  String endereco;
  String numero;
  String email;
  String password;
  
  UserModel({
    this.id,
    this.nome,
    this.birthdate,
    this.cpf,
    this.cep,
    this.endereco,
    this.numero,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': nome,
      'birthdate': birthdate,
      'cpf': cpf,
      'cep': cep,
      'address': endereco,
      'number': numero,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserModel(
      id: map['id'],
      nome: map['nome'],
      birthdate: map['birthdate'],
      cpf: map['cpf'],
      cep: map['cep'],
      endereco: map['endereco'],
      numero: map['numero'],
      email: map['email'],
      password: map['password'],
    );
  }

  @override
  String toString() {
    return 'UserModel(nome: $nome, birthdate: $birthdate, cpf: $cpf, cep: $cep, endereco: $endereco, numero: $numero, email: $email, password: $password)';
  }
}
