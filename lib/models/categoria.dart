class Categoria {
  final int? categoriaId; // Hacer opcional
  final String nombre;
  final String tipo;

  Categoria(
      {this.categoriaId, // Cambiado a opcional
      required this.nombre,
      required this.tipo});

  Map<String, dynamic> toMap() {
    return {
      'categoria_id': categoriaId,
      'nombre': nombre,
      'tipo': tipo,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      categoriaId: map['categoria_id'] as int?,
      nombre: map['nombre'],
      tipo: map['tipo'],
    );
  }
}
