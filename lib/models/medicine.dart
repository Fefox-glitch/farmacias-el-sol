class Medicine {
  final String id;
  final String nombre;
  final String descripcion;
  final String principioActivo;
  final String presentacion;
  final String? laboratorio;
  final String? contraindicaciones;
  final String? efectosSecundarios;
  final String? viaAdministracion;
  final bool requiereReceta;

  Medicine({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.principioActivo,
    required this.presentacion,
    this.laboratorio,
    this.contraindicaciones,
    this.efectosSecundarios,
    this.viaAdministracion,
    this.requiereReceta = false,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      principioActivo: json['principioActivo'] as String,
      presentacion: json['presentacion'] as String,
      laboratorio: json['laboratorio'] as String?,
      contraindicaciones: json['contraindicaciones'] as String?,
      efectosSecundarios: json['efectosSecundarios'] as String?,
      viaAdministracion: json['viaAdministracion'] as String?,
      requiereReceta: json['requiereReceta'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'principioActivo': principioActivo,
      'presentacion': presentacion,
      'laboratorio': laboratorio,
      'contraindicaciones': contraindicaciones,
      'efectosSecundarios': efectosSecundarios,
      'viaAdministracion': viaAdministracion,
      'requiereReceta': requiereReceta,
    };
  }

  Medicine copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? principioActivo,
    String? presentacion,
    String? laboratorio,
    String? contraindicaciones,
    String? efectosSecundarios,
    String? viaAdministracion,
    bool? requiereReceta,
  }) {
    return Medicine(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      principioActivo: principioActivo ?? this.principioActivo,
      presentacion: presentacion ?? this.presentacion,
      laboratorio: laboratorio ?? this.laboratorio,
      contraindicaciones: contraindicaciones ?? this.contraindicaciones,
      efectosSecundarios: efectosSecundarios ?? this.efectosSecundarios,
      viaAdministracion: viaAdministracion ?? this.viaAdministracion,
      requiereReceta: requiereReceta ?? this.requiereReceta,
    );
  }

  @override
  String toString() {
    return 'Medicine(id: $id, nombre: $nombre, principioActivo: $principioActivo)';
  }
}
