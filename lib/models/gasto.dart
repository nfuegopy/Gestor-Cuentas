class Gasto {
  final int gastoId;
  final int usuarioId;
  final int categoriaId;
  final DateTime fecha;
  final double monto;
  final String notas;

  Gasto({
    required this.gastoId,
    required this.usuarioId,
    required this.categoriaId,
    required this.fecha,
    required this.monto,
    required this.notas,
  });

  Map<String, dynamic> toMap() {
    return {
      'gasto_id': gastoId,
      'usuario_id': usuarioId,
      'categoria_id': categoriaId,
      'fecha': fecha.toIso8601String(),
      'monto': monto,
      'notas': notas,
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      gastoId: map['gasto_id'] as int,
      usuarioId: map['usuario_id'] as int,
      categoriaId: map['categoria_id'] as int,
      fecha: DateTime.parse(map['fecha'] as String),
      monto: (map['monto'] is int)
          ? (map['monto'] as int).toDouble()
          : map['monto'] as double,
      notas: map['notas'] as String,
    );
  }
}
