import 'package:flutter/material.dart';
import 'package:arica_eventos/models/evento.dart';
import 'package:arica_eventos/services/evento_service.dart';
import 'package:arica_eventos/utils/constants.dart';
import 'package:arica_eventos/widgets/event_card.dart';
import 'package:arica_eventos/screens/public/event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventoService _eventoService = EventoService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Evento> _eventos = [];
  List<String> _categorias = [];
  bool _isLoading = true;
  String? _selectedCategoria;
  String _searchQuery = '';
  String _sortBy = 'fecha';
  bool _sortAscending = true;
  int _currentPage = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Cargar categorías
    final categorias = await _eventoService.getCategorias();
    
    // Cargar eventos
    final eventos = await _eventoService.getEventos(
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      categoria: _selectedCategoria,
      orderBy: _sortBy,
      ascending: _sortAscending,
      limit: AppPagination.itemsPerPage,
      offset: _currentPage * AppPagination.itemsPerPage,
    );

    // Obtener conteo total
    final count = await _eventoService.getEventosCount(
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      categoria: _selectedCategoria,
    );

    setState(() {
      _categorias = categorias;
      _eventos = eventos;
      _totalCount = count;
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 0;
    });
    _loadData();
  }

  void _onCategoriaSelected(String? categoria) {
    setState(() {
      _selectedCategoria = categoria;
      _currentPage = 0;
    });
    _loadData();
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = true;
      }
      _currentPage = 0;
    });
    _loadData();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_totalCount / AppPagination.itemsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar con hero section
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
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
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_available,
                            size: 64,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const Text(
                            'AricaEventos',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppFontSize.xxxl,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          const Text(
                            'Descubre los mejores eventos de Arica',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppFontSize.lg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
                icon: const Icon(Icons.admin_panel_settings, color: AppColors.textPrimary),
                label: const Text(
                  'Admin',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  // Barra de búsqueda
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Buscar eventos...',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Filtros de categoría
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    alignment: WrapAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: _selectedCategoria == null,
                        onSelected: (_) => _onCategoriaSelected(null),
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: _selectedCategoria == null
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      ..._categorias.map((categoria) {
                        final isSelected = _selectedCategoria == categoria;
                        return FilterChip(
                          label: Text(AppCategories.getDisplayName(categoria)),
                          selected: isSelected,
                          onSelected: (_) => _onCategoriaSelected(categoria),
                          backgroundColor: AppColors.surface,
                          selectedColor: AppCategories.getGradient(categoria)[0],
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                          avatar: Icon(
                            AppCategories.getIcon(categoria),
                            size: 18,
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Ordenamiento
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ordenar por:',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppFontSize.sm,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      TextButton.icon(
                        onPressed: () => _onSortChanged('fecha'),
                        icon: Icon(
                          _sortBy == 'fecha'
                              ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                              : Icons.calendar_today,
                          size: 16,
                        ),
                        label: const Text('Fecha'),
                        style: TextButton.styleFrom(
                          foregroundColor: _sortBy == 'fecha'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _onSortChanged('titulo'),
                        icon: Icon(
                          _sortBy == 'titulo'
                              ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                              : Icons.sort_by_alpha,
                          size: 16,
                        ),
                        label: const Text('Título'),
                        style: TextButton.styleFrom(
                          foregroundColor: _sortBy == 'titulo'
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // Grid de eventos
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                )
              : _eventos.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 64,
                                color: AppColors.textMuted,
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                'No se encontraron eventos',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: AppFontSize.lg,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 350,
                          mainAxisSpacing: AppSpacing.lg,
                          crossAxisSpacing: AppSpacing.lg,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final evento = _eventos[index];
                            return EventCard(
                              evento: evento,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailScreen(evento: evento),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: _eventos.length,
                        ),
                      ),
                    ),

          // Paginación
          if (!_isLoading && _eventos.isNotEmpty && totalPages > 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _currentPage > 0
                          ? () => _onPageChanged(_currentPage - 1)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      color: AppColors.textPrimary,
                      disabledColor: AppColors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Página ${_currentPage + 1} de $totalPages',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppFontSize.md,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    IconButton(
                      onPressed: _currentPage < totalPages - 1
                          ? () => _onPageChanged(_currentPage + 1)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      color: AppColors.textPrimary,
                      disabledColor: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
