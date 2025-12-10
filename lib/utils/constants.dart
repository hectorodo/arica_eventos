import 'package:flutter/material.dart';

// Colores principales
class AppColors {
  // Colores base
  static const Color primary = Color(0xFF6366F1); // Indigo vibrante
  static const Color secondary = Color(0xFFEC4899); // Rosa vibrante
  static const Color accent = Color(0xFF8B5CF6); // Púrpura
  static const Color success = Color(0xFF10B981); // Verde
  static const Color warning = Color(0xFFF59E0B); // Amarillo
  static const Color error = Color(0xFFEF4444); // Rojo
  
  // Fondos
  static const Color background = Color(0xFF0F172A); // Azul oscuro
  static const Color surface = Color(0xFF1E293B); // Azul gris oscuro
  static const Color surfaceLight = Color(0xFF334155); // Azul gris medio
  
  // Texto
  static const Color textPrimary = Color(0xFFF1F5F9); // Blanco suave
  static const Color textSecondary = Color(0xFF94A3B8); // Gris azulado
  static const Color textMuted = Color(0xFF64748B); // Gris
  
  // Gradientes por categoría
  static const List<Color> musicaGradient = [Color(0xFFEC4899), Color(0xFF8B5CF6)];
  static const List<Color> deportesGradient = [Color(0xFF10B981), Color(0xFF06B6D4)];
  static const List<Color> culturaGradient = [Color(0xFFF59E0B), Color(0xFFEF4444)];
  static const List<Color> generalGradient = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
  static const List<Color> gastronomiaGradient = [Color(0xFFEF4444), Color(0xFFF97316)];
  static const List<Color> tecnologiaGradient = [Color(0xFF06B6D4), Color(0xFF6366F1)];
}

// Categorías disponibles
class AppCategories {
  static const List<String> all = [
    'musica',
    'deportes',
    'cultura',
    'gastronomia',
    'tecnologia',
    'general',
  ];

  static String getDisplayName(String categoria) {
    final names = {
      'musica': 'Música',
      'deportes': 'Deportes',
      'cultura': 'Cultura',
      'gastronomia': 'Gastronomía',
      'tecnologia': 'Tecnología',
      'general': 'General',
    };
    return names[categoria.toLowerCase()] ?? categoria;
  }

  static List<Color> getGradient(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'musica':
        return AppColors.musicaGradient;
      case 'deportes':
        return AppColors.deportesGradient;
      case 'cultura':
        return AppColors.culturaGradient;
      case 'gastronomia':
        return AppColors.gastronomiaGradient;
      case 'tecnologia':
        return AppColors.tecnologiaGradient;
      default:
        return AppColors.generalGradient;
    }
  }

  static IconData getIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'musica':
        return Icons.music_note;
      case 'deportes':
        return Icons.sports_soccer;
      case 'cultura':
        return Icons.palette;
      case 'gastronomia':
        return Icons.restaurant;
      case 'tecnologia':
        return Icons.computer;
      default:
        return Icons.event;
    }
  }
}

// Espaciado
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// Border radius
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

// Tamaños de fuente
class AppFontSize {
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
}

// Constantes de paginación
class AppPagination {
  static const int itemsPerPage = 12;
}
