import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:arica_eventos/models/evento.dart';
import 'package:arica_eventos/utils/constants.dart';

class EventDetailScreen extends StatelessWidget {
  final Evento evento;

  const EventDetailScreen({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = AppCategories.getGradient(evento.categoria);
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'es');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar con gradiente
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      AppCategories.getIcon(evento.categoria),
                      size: 80,
                      color: AppColors.textPrimary.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Contenido del evento
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoría y badge gratuito
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: gradient),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  AppCategories.getIcon(evento.categoria),
                                  size: 18,
                                  color: AppColors.textPrimary,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  AppCategories.getDisplayName(evento.categoria),
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: AppFontSize.md,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          if (evento.esGratuito)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(AppRadius.full),
                              ),
                              child: const Text(
                                'EVENTO GRATUITO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.sm,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Título
                      Text(
                        evento.titulo,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppFontSize.xxxl,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Información del evento
                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        title: 'Fecha',
                        content: dateFormat.format(evento.fecha),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildInfoCard(
                        icon: Icons.location_on,
                        title: 'Lugar',
                        content: evento.lugar,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      if (evento.edadMinima > 0)
                        _buildInfoCard(
                          icon: Icons.person,
                          title: 'Edad mínima',
                          content: '+${evento.edadMinima} años',
                        ),
                      
                      if (evento.edadMinima > 0)
                        const SizedBox(height: AppSpacing.md),

                      _buildInfoCard(
                        icon: Icons.attach_money,
                        title: 'Entrada',
                        content: evento.esGratuito ? 'Gratuita' : 'De pago',
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Descripción
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Descripción',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: AppFontSize.xl,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              evento.descripcion,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppFontSize.md,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppFontSize.sm,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppFontSize.lg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
