import 'package:arica_eventos/config/supabase_config.dart';
import 'package:arica_eventos/models/evento.dart';

class EventoService {
  static const String tableName = 'Eventos';

  // Obtener todos los eventos con filtros opcionales
  Future<List<Evento>> getEventos({
    String? searchQuery,
    String? categoria,
    String? orderBy = 'fecha',
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = SupabaseConfig.client.from(tableName).select();

      // Aplicar búsqueda por título o descripción
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('titulo.ilike.%$searchQuery%,descripcion.ilike.%$searchQuery%');
      }

      // Filtrar por categoría
      if (categoria != null && categoria.isNotEmpty) {
        query = query.eq('categoria', categoria);
      }

      // Ordenar
      query = query.order(orderBy, ascending: ascending);

      // Paginación
      if (limit != null) {
        query = query.limit(limit);
      }
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return (response as List).map((json) => Evento.fromJson(json)).toList();
    } catch (e) {
      print('Error al obtener eventos: $e');
      return [];
    }
  }

  // Obtener un evento por ID
  Future<Evento?> getEventoById(String id) async {
    try {
      final response = await SupabaseConfig.client
          .from(tableName)
          .select()
          .eq('id', id)
          .single();
      
      return Evento.fromJson(response);
    } catch (e) {
      print('Error al obtener evento: $e');
      return null;
    }
  }

  // Crear un nuevo evento
  Future<Evento?> createEvento(Evento evento) async {
    try {
      final response = await SupabaseConfig.client
          .from(tableName)
          .insert(evento.toJson())
          .select()
          .single();
      
      return Evento.fromJson(response);
    } catch (e) {
      print('Error al crear evento: $e');
      return null;
    }
  }

  // Actualizar un evento existente
  Future<Evento?> updateEvento(String id, Evento evento) async {
    try {
      final response = await SupabaseConfig.client
          .from(tableName)
          .update(evento.toJson())
          .eq('id', id)
          .select()
          .single();
      
      return Evento.fromJson(response);
    } catch (e) {
      print('Error al actualizar evento: $e');
      return null;
    }
  }

  // Eliminar un evento
  Future<bool> deleteEvento(String id) async {
    try {
      await SupabaseConfig.client
          .from(tableName)
          .delete()
          .eq('id', id);
      
      return true;
    } catch (e) {
      print('Error al eliminar evento: $e');
      return false;
    }
  }

  // Obtener el conteo total de eventos (para paginación)
  Future<int> getEventosCount({
    String? searchQuery,
    String? categoria,
  }) async {
    try {
      // Simplemente obtenemos todos los eventos que coinciden y contamos
      final eventos = await getEventos(
        searchQuery: searchQuery,
        categoria: categoria,
      );
      return eventos.length;
    } catch (e) {
      print('Error al contar eventos: $e');
      return 0;
    }
  }

  // Obtener categorías únicas
  Future<List<String>> getCategorias() async {
    try {
      final response = await SupabaseConfig.client
          .from(tableName)
          .select('categoria');
      
      final categorias = (response as List)
          .map((item) => item['categoria'] as String)
          .toSet()
          .toList();
      
      categorias.sort();
      return categorias;
    } catch (e) {
      print('Error al obtener categorías: $e');
      return [];
    }
  }
}
