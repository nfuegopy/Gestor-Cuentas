class Ingreso {
  final int ingresoId;
  final int usuarioId;
  final int categoriaId;
  final DateTime fecha;
  final double monto;
  final String notas;

  Ingreso({
    required this.ingresoId,
    required this.usuarioId,
    required this.categoriaId,
    required this.fecha,
    required this.monto,
    required this.notas,
  });

  Map<String, dynamic> toMap() {
    return {
      'ingreso_id': ingresoId,
      'usuario_id': usuarioId,
      'categoria_id': categoriaId,
      'fecha': fecha.toIso8601String(),
      'monto': monto,
      'notas': notas,
    };
  }

  factory Ingreso.fromMap(Map<String, dynamic> map) {
    return Ingreso(
      ingresoId: map['ingreso_id'] as int,
      usuarioId: map['usuario_id'] as int,
      categoriaId: map['categoria_id'] as int,
      fecha: DateTime.parse(map['fecha'] as String),
      monto: map['monto'] as double,
      notas: map['notas'] as String,
    );
  }
}
