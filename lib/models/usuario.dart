class Usuario {
  final int usuarioId;
  final String nombre;
  final String? correo;

  Usuario({required this.usuarioId, required this.nombre, this.correo});

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      usuarioId: map['usuario_id'] as int,
      nombre: map['nombre'] as String,
      correo: map['correo'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'nombre': nombre,
      'correo': correo,
    };
  }
}
