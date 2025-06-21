class User {
  final String id;
  final String nombre;
  final String email;
  final String? telefono;
  final List<Dependiente> dependientes;
  final List<String> alergias;
  final Map<String, String> condicionesMedicas;
  final DateTime fechaRegistro;
  final String? photoUrl;

  User({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.dependientes = const [],
    this.alergias = const [],
    this.condicionesMedicas = const {},
    required this.fechaRegistro,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      dependientes: (json['dependientes'] as List<dynamic>?)
          ?.map((e) => Dependiente.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      alergias:
          (json['alergias'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      condicionesMedicas: (json['condicionesMedicas'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as String)) ??
          {},
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'dependientes': dependientes.map((d) => d.toJson()).toList(),
      'alergias': alergias,
      'condicionesMedicas': condicionesMedicas,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'photoUrl': photoUrl,
    };
  }

  User copyWith({
    String? id,
    String? nombre,
    String? email,
    String? telefono,
    List<Dependiente>? dependientes,
    List<String>? alergias,
    Map<String, String>? condicionesMedicas,
    DateTime? fechaRegistro,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      dependientes: dependientes ?? this.dependientes,
      alergias: alergias ?? this.alergias,
      condicionesMedicas: condicionesMedicas ?? this.condicionesMedicas,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, nombre: $nombre, email: $email)';
  }
}

class Dependiente {
  final String id;
  final String nombre;
  final DateTime fechaNacimiento;
  final String parentesco;
  final List<String> alergias;
  final Map<String, String> condicionesMedicas;
  final String? notas;

  Dependiente({
    required this.id,
    required this.nombre,
    required this.fechaNacimiento,
    required this.parentesco,
    this.alergias = const [],
    this.condicionesMedicas = const {},
    this.notas,
  });

  factory Dependiente.fromJson(Map<String, dynamic> json) {
    return Dependiente(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      fechaNacimiento: DateTime.parse(json['fechaNacimiento'] as String),
      parentesco: json['parentesco'] as String,
      alergias:
          (json['alergias'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      condicionesMedicas: (json['condicionesMedicas'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as String)) ??
          {},
      notas: json['notas'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'parentesco': parentesco,
      'alergias': alergias,
      'condicionesMedicas': condicionesMedicas,
      'notas': notas,
    };
  }

  Dependiente copyWith({
    String? id,
    String? nombre,
    DateTime? fechaNacimiento,
    String? parentesco,
    List<String>? alergias,
    Map<String, String>? condicionesMedicas,
    String? notas,
  }) {
    return Dependiente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      parentesco: parentesco ?? this.parentesco,
      alergias: alergias ?? this.alergias,
      condicionesMedicas: condicionesMedicas ?? this.condicionesMedicas,
      notas: notas ?? this.notas,
    );
  }

  int get edad {
    final now = DateTime.now();
    var edad = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month &&
            now.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  @override
  String toString() {
    return 'Dependiente(id: $id, nombre: $nombre, edad: $edad)';
  }
}
