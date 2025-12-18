import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/crop_grid_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/quick_actions_bottom_sheet_widget.dart';
import './widgets/search_header_widget.dart';

class CropDatabase extends StatefulWidget {
  const CropDatabase({super.key});

  @override
  State<CropDatabase> createState() => _CropDatabaseState();
}

class _CropDatabaseState extends State<CropDatabase> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allCrops = [];
  List<Map<String, dynamic>> _filteredCrops = [];
  List<String> _searchSuggestions = [];
  Map<String, List<String>> _selectedFilters = {};
  Set<String> _favoriteCrops = {};

  bool _isLoading = true;
  bool _showSuggestions = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeCropData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeCropData() {
    // Mock data for 12+ major Cameroon crops
    _allCrops = [
      {
        "id": "1",
        "localName": "Maïs",
        "scientificName": "Zea mays",
        "category": "Céréales",
        "difficulty": "Facile",
        "image":
            "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5, 9, 10],
        "harvestMonths": [7, 8, 12, 1],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Saison des pluies",
      },
      {
        "id": "2",
        "localName": "Manioc",
        "scientificName": "Manihot esculenta",
        "category": "Tubercules",
        "difficulty": "Facile",
        "image":
            "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5, 6, 7, 8, 9, 10],
        "harvestMonths": [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Toute l'année",
      },
      {
        "id": "3",
        "localName": "Arachide",
        "scientificName": "Arachis hypogaea",
        "category": "Légumineuses",
        "difficulty": "Moyen",
        "image":
            "https://images.unsplash.com/photo-1608797178974-15b35a64ede9?w=400&h=300&fit=crop",
        "plantingMonths": [4, 5, 6],
        "harvestMonths": [8, 9, 10],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Saison des pluies",
      },
      {
        "id": "4",
        "localName": "Cacao",
        "scientificName": "Theobroma cacao",
        "category": "Fruits",
        "difficulty": "Difficile",
        "image":
            "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5, 9, 10],
        "harvestMonths": [10, 11, 12, 1, 2, 3, 4, 5],
        "varieties": ["Variétés traditionnelles", "Variétés hybrides"],
        "season": "Saison des pluies",
      },
      {
        "id": "5",
        "localName": "Café",
        "scientificName": "Coffea arabica",
        "category": "Fruits",
        "difficulty": "Difficile",
        "image":
            "https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5],
        "harvestMonths": [10, 11, 12, 1, 2],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Saison des pluies",
      },
      {
        "id": "6",
        "localName": "Banane Plantain",
        "scientificName": "Musa paradisiaca",
        "category": "Fruits",
        "difficulty": "Moyen",
        "image":
            "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5, 6, 7, 8, 9, 10],
        "harvestMonths": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "varieties": ["Variétés traditionnelles"],
        "season": "Toute l'année",
      },
      {
        "id": "7",
        "localName": "Igname",
        "scientificName": "Dioscorea spp.",
        "category": "Tubercules",
        "difficulty": "Moyen",
        "image":
            "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5],
        "harvestMonths": [11, 12, 1, 2],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Saison des pluies",
      },
      {
        "id": "8",
        "localName": "Riz",
        "scientificName": "Oryza sativa",
        "category": "Céréales",
        "difficulty": "Moyen",
        "image":
            "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=300&fit=crop",
        "plantingMonths": [4, 5, 6, 9, 10],
        "harvestMonths": [8, 9, 12, 1],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Saison des pluies",
      },
      {
        "id": "9",
        "localName": "Tomate",
        "scientificName": "Solanum lycopersicum",
        "category": "Légumes",
        "difficulty": "Moyen",
        "image":
            "https://images.unsplash.com/photo-1546470427-e26264be0b0d?w=400&h=300&fit=crop",
        "plantingMonths": [2, 3, 4, 8, 9, 10],
        "harvestMonths": [5, 6, 7, 11, 12, 1],
        "varieties": [
          "Variétés traditionnelles",
          "Variétés améliorées",
          "Variétés hybrides"
        ],
        "season": "Saison sèche",
      },
      {
        "id": "10",
        "localName": "Haricot",
        "scientificName": "Phaseolus vulgaris",
        "category": "Légumineuses",
        "difficulty": "Facile",
        "image":
            "https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5, 9, 10],
        "harvestMonths": [6, 7, 8, 12, 1],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Saison des pluies",
      },
      {
        "id": "11",
        "localName": "Palmier à Huile",
        "scientificName": "Elaeis guineensis",
        "category": "Fruits",
        "difficulty": "Difficile",
        "image":
            "https://images.unsplash.com/photo-1582560469781-1965b9af903d?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5, 9, 10],
        "harvestMonths": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Saison des pluies",
      },
      {
        "id": "12",
        "localName": "Ananas",
        "scientificName": "Ananas comosus",
        "category": "Fruits",
        "difficulty": "Moyen",
        "image":
            "https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=400&h=300&fit=crop",
        "plantingMonths": [3, 4, 5, 6, 7, 8, 9, 10],
        "harvestMonths": [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        "varieties": ["Variétés traditionnelles", "Variétés améliorées"],
        "season": "Toute l'année",
      },
    ];

    setState(() {
      _filteredCrops = List.from(_allCrops);
      _isLoading = false;
    });

    // Load favorite crops from storage
    _loadFavoriteCrops();
  }

  void _loadFavoriteCrops() {
    // Mock favorite crops
    setState(() {
      _favoriteCrops = {"1", "3", "9"};
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _searchSuggestions.clear();
      });
      _applyFilters();
      return;
    }

    // Generate suggestions
    final suggestions = _allCrops
        .where((crop) =>
            (crop["localName"] as String).toLowerCase().contains(query) ||
            (crop["scientificName"] as String).toLowerCase().contains(query))
        .map((crop) => crop["localName"] as String)
        .take(5)
        .toList();

    setState(() {
      _searchSuggestions = suggestions;
      _showSuggestions = suggestions.isNotEmpty;
    });

    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();
    List<Map<String, dynamic>> filtered = List.from(_allCrops);

    // Apply search filter
    if (query.isNotEmpty) {
      filtered = filtered.where((crop) {
        final localName = (crop["localName"] as String).toLowerCase();
        final scientificName = (crop["scientificName"] as String).toLowerCase();
        return localName.contains(query) || scientificName.contains(query);
      }).toList();
    }

    // Apply category filters
    if (_selectedFilters.containsKey('category') &&
        _selectedFilters['category']!.isNotEmpty) {
      filtered = filtered.where((crop) {
        return _selectedFilters['category']!.contains(crop["category"]);
      }).toList();
    }

    // Apply season filters
    if (_selectedFilters.containsKey('season') &&
        _selectedFilters['season']!.isNotEmpty) {
      filtered = filtered.where((crop) {
        return _selectedFilters['season']!.contains(crop["season"]);
      }).toList();
    }

    // Apply difficulty filters
    if (_selectedFilters.containsKey('difficulty') &&
        _selectedFilters['difficulty']!.isNotEmpty) {
      filtered = filtered.where((crop) {
        return _selectedFilters['difficulty']!.contains(crop["difficulty"]);
      }).toList();
    }

    // Apply varieties filters
    if (_selectedFilters.containsKey('varieties') &&
        _selectedFilters['varieties']!.isNotEmpty) {
      filtered = filtered.where((crop) {
        final cropVarieties = (crop["varieties"] as List).cast<String>();
        return _selectedFilters['varieties']!
            .any((filter) => cropVarieties.contains(filter));
      }).toList();
    }

    setState(() {
      _filteredCrops = filtered;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Base de données des cultures mise à jour'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedFilters: _selectedFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _selectedFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> crop) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsBottomSheetWidget(
        cropData: crop,
        isFavorite: _favoriteCrops.contains(crop["id"]),
        onAddToFavorites: () => _toggleFavorite(crop["id"] as String),
        onRemoveFromFavorites: () => _toggleFavorite(crop["id"] as String),
        onShareInformation: () => _shareCropInfo(crop),
        onSetPlantingReminder: () => _setPlantingReminder(crop),
        onViewDetails: () => _viewCropDetails(crop),
      ),
    );
  }

  void _toggleFavorite(String cropId) {
    setState(() {
      if (_favoriteCrops.contains(cropId)) {
        _favoriteCrops.remove(cropId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Retiré des favoris')),
        );
      } else {
        _favoriteCrops.add(cropId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ajouté aux favoris')),
        );
      }
    });
  }

  void _shareCropInfo(Map<String, dynamic> crop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage des informations sur ${crop["localName"]}'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _setPlantingReminder(Map<String, dynamic> crop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rappel de plantation défini pour ${crop["localName"]}'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  void _viewCropDetails(Map<String, dynamic> crop) {
    // Navigate to crop details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation vers les détails de ${crop["localName"]}'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _removeFilter(String filterType, String filterValue) {
    setState(() {
      if (_selectedFilters.containsKey(filterType)) {
        _selectedFilters[filterType]!.remove(filterValue);
        if (_selectedFilters[filterType]!.isEmpty) {
          _selectedFilters.remove(filterType);
        }
      }
    });
    _applyFilters();
  }

  List<Map<String, dynamic>> _getActiveFiltersForChips() {
    List<Map<String, dynamic>> activeFilters = [];

    _selectedFilters.forEach((type, values) {
      for (String value in values) {
        // Count crops matching this filter
        int count = _allCrops.where((crop) {
          switch (type) {
            case 'category':
              return crop["category"] == value;
            case 'season':
              return crop["season"] == value;
            case 'difficulty':
              return crop["difficulty"] == value;
            case 'varieties':
              return (crop["varieties"] as List).contains(value);
            default:
              return false;
          }
        }).length;

        activeFilters.add({
          "type": type,
          "value": value,
          "count": count,
        });
      }
    });

    return activeFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Base de Données des Cultures',
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to My Crops
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navigation vers Mes Cultures')),
              );
            },
            icon: CustomIconWidget(
              iconName: 'bookmark',
              color: Theme.of(context).appBarTheme.foregroundColor!,
              size: 24,
            ),
            tooltip: 'Mes Cultures',
          ),
        ],
      ),
      body: Column(
        children: [
          SearchHeaderWidget(
            searchController: _searchController,
            onFilterPressed: _showFilterBottomSheet,
            onSearchChanged: (query) {
              // Search change is handled by listener
            },
            suggestions: _searchSuggestions,
            showSuggestions: _showSuggestions,
          ),
          FilterChipsWidget(
            activeFilters: _getActiveFiltersForChips(),
            onFilterRemoved: _removeFilter,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: CropGridWidget(
                crops: _filteredCrops,
                favoriteCrops: _favoriteCrops,
                isLoading: _isLoading || _isRefreshing,
                onCropTap: _viewCropDetails,
                onCropLongPress: _showQuickActions,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1, // Crops tab active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-dashboard');
              break;
            case 1:
              // Already on crops screen
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/community-forum');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/user-profile');
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to My Crops tracking
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Navigation vers le suivi de Mes Cultures'),
              backgroundColor: AppTheme.successLight,
            ),
          );
        },
        child: CustomIconWidget(
          iconName: 'agriculture',
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor!,
          size: 24,
        ),
        tooltip: 'Mes Cultures',
      ),
    );
  }
}
