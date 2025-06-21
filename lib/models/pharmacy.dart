class Pharmacy {
  final String id;
  final String nombre;
  final String direccion;
  final double lat;
  final double lng;
  final String horario;
  final String? telefono;
  final bool servicioADomicilio;
  final List<String> serviciosAdicionales;
  final Map<String, String> horarioSemanal;

  Pharmacy({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.lat,
    required this.lng,
    required this.horario,
    this.telefono,
    this.servicioADomicilio = false,
    this.serviciosAdicionales = const [],
    this.horarioSemanal = const {},
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      horario: json['horario'] as String,
      telefono: json['telefono'] as String?,
      servicioADomicilio: json['servicioADomicilio'] as bool? ?? false,
      serviciosAdicionales: (json['serviciosAdicionales'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      horarioSemanal: (json['horarioSemanal'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as String)) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'lat': lat,
      'lng': lng,
      'horario': horario,
      'telefono': telefono,
      'servicioADomicilio': servicioADomicilio,
      'serviciosAdicionales': serviciosAdicionales,
      'horarioSemanal': horarioSemanal,
    };
  }

  Pharmacy copyWith({
    String? id,
    String? nombre,
    String? direccion,
    double? lat,
    double? lng,
    String? horario,
    String? telefono,
    bool? servicioADomicilio,
    List<String>? serviciosAdicionales,
    Map<String, String>? horarioSemanal,
  }) {
    return Pharmacy(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      horario: horario ?? this.horario,
      telefono: telefono ?? this.telefono,
      servicioADomicilio: servicioADomicilio ?? this.servicioADomicilio,
      serviciosAdicionales: serviciosAdicionales ?? this.serviciosAdicionales,
      horarioSemanal: horarioSemanal ?? this.horarioSemanal,
    );
  }

  double distanceTo(double userLat, double userLng) {
    // TODO: Implementar cálculo de distancia usando la fórmula de Haversine
    // Por ahora retornamos una distancia euclidiana simple
    return ((lat - userLat) * (lat - userLat) + 
            (lng - userLng) * (lng - userLng)).abs();
  }

  bool get isOpen {
    // TODO: Implementar lógica real de verificación de horario
    return true;
  }

  @override
  String toString() {
    return 'Pharmacy(id: $id, nombre: $nombre, direccion: $direccion)';
  }
}
