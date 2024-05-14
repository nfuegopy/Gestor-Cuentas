class Frecuencia {
  final int? frecuenciaId;
  final String descripcion;

  Frecuencia({this.frecuenciaId, required this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'frecuencia_id': frecuenciaId,
      'descripcion': descripcion,
    };
  }

  factory Frecuencia.fromMap(Map<String, dynamic> map) {
    return Frecuencia(
      frecuenciaId: map['frecuencia_id'] as int?,
      descripcion: map['descripcion'] as String,
    );
  }
}
