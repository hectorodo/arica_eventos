class Evento {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final bool esGratuito;
  final int edadMinima;
  final String categoria;
  final String lugar;

  Evento({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.esGratuito,
    required this.edadMinima,
    required this.categoria,
    required this.lugar,
  });

  // Crear un Evento desde JSON (Supabase)
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      fecha: DateTime.parse(json['fecha'] as String),
      esGratuito: json['es_gratuito'] as bool? ?? true,
      edadMinima: (json['edad_minima'] as num?)?.toInt() ?? 0,
      categoria: json['categoria'] as String? ?? 'general',
      lugar: json['lugar'] as String? ?? '',
    );
  }

  // Convertir Evento a JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String().split('T')[0], // Solo fecha, sin hora
      'es_gratuito': esGratuito,
      'edad_minima': edadMinima,
      'categoria': categoria,
      'lugar': lugar,
    };
  }

  // Crear una copia del evento con campos modificados
  Evento copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fecha,
    bool? esGratuito,
    int? edadMinima,
    String? categoria,
    String? lugar,
  }) {
    return Evento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      esGratuito: esGratuito ?? this.esGratuito,
      edadMinima: edadMinima ?? this.edadMinima,
      categoria: categoria ?? this.categoria,
      lugar: lugar ?? this.lugar,
    );
  }
}
