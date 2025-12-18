import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/crop_health_card_widget.dart';
import './widgets/farming_task_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/seasonal_recommendations_widget.dart';
import './widgets/weather_card_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  bool _isOffline = false;
  DateTime _lastUpdated = DateTime.now();
  int _currentBottomNavIndex = 0;

  // Mock data
  final Map<String, dynamic> _weatherData = {
    "location": "Yaoundé, Cameroun",
    "condition": "Partiellement nuageux",
    "temperature": 28,
    "feelsLike": 32,
    "humidity": 75,
    "windSpeed": 12,
    "visibility": 8,
    "alert": "Risque de pluie dans 2 heures - Protégez vos cultures sensibles",
  };

  final List<Map<String, dynamic>> _farmingTasks = [
    {
      "id": "task_1",
      "title": "Arrosage des tomates",
      "description": "Irrigation matinale des plants de tomates dans la serre",
      "category": "Irrigation",
      "priority": "Urgent",
      "time": "06:00",
      "completed": false,
    },
    {
      "id": "task_2",
      "title": "Fertilisation du maïs",
      "description": "Application d'engrais organique sur la parcelle de maïs",
      "category": "Fertilisation",
      "priority": "Important",
      "time": "08:30",
      "completed": false,
    },
    {
      "id": "task_3",
      "title": "Inspection des cacaoyers",
      "description": "Vérification de l'état sanitaire des cacaoyers",
      "category": "Traitement",
      "priority": "Normal",
      "time": "10:00",
      "completed": true,
    },
    {
      "id": "task_4",
      "title": "Récolte des haricots",
      "description": "Collecte des haricots verts matures",
      "category": "Récolte",
      "priority": "Important",
      "time": "15:00",
      "completed": false,
    },
  ];

  final List<Map<String, dynamic>> _cropHealthData = [
    {
      "id": "crop_1",
      "cropName": "Tomates Cerises",
      "location": "Serre A - Section 2",
      "image":
          "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg",
      "healthStatus": "Bon",
      "analysisDate": "Il y a 2 heures",
      "issues": ["Légère carence en potassium"],
    },
    {
      "id": "crop_2",
      "cropName": "Maïs Jaune",
      "location": "Champ Nord - Parcelle 1",
      "image":
          "https://images.pexels.com/photos/547263/pexels-photo-547263.jpeg",
      "healthStatus": "Excellent",
      "analysisDate": "Hier",
      "issues": [],
    },
    {
      "id": "crop_3",
      "cropName": "Cacaoyers",
      "location": "Plantation Sud",
      "image":
          "https://images.pexels.com/photos/4022092/pexels-photo-4022092.jpeg",
      "healthStatus": "Moyen",
      "analysisDate": "Il y a 3 heures",
      "issues": [
        "Présence de mirides",
        "Humidité excessive",
        "Besoin de taille"
      ],
    },
  ];

  final List<Map<String, dynamic>> _seasonalRecommendations = [
    {
      "id": "rec_1",
      "title": "Préparation pour la saison des pluies",
      "category": "Préparation du sol",
      "description":
          "Préparez vos cultures pour la saison des pluies qui approche. Assurez-vous que le drainage est optimal et que vos plants sont bien protégés.",
      "timeframe": "2-3 semaines",
      "priority": "Haute",
      "benefits": [
        "Évite l'engorgement des racines",
        "Améliore la survie des plants",
        "Optimise l'absorption des nutriments"
      ],
    },
    {
      "id": "rec_2",
      "title": "Plantation de légumes de saison",
      "category": "Plantation",
      "description":
          "C'est le moment idéal pour planter des légumes adaptés à la saison actuelle comme les épinards, les radis et les carottes.",
      "timeframe": "Maintenant",
      "priority": "Moyenne",
      "benefits": [
        "Croissance optimale",
        "Résistance naturelle aux maladies",
        "Meilleur rendement"
      ],
    },
    {
      "id": "rec_3",
      "title": "Traitement préventif contre les parasites",
      "category": "Traitement",
      "description":
          "Appliquez des traitements préventifs naturels pour protéger vos cultures contre les parasites saisonniers.",
      "timeframe": "Cette semaine",
      "priority": "Haute",
      "benefits": [
        "Prévention des infestations",
        "Protection écologique",
        "Économies sur les traitements curatifs"
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkConnectivity();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isOffline = false; // In real app, use connectivity_plus package
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            // Status indicators
            if (_isOffline) _buildOfflineIndicator(),

            // Main content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),

                  // Weather card
                  WeatherCardWidget(
                    weatherData: _weatherData,
                    onTap: () =>
                        Navigator.pushNamed(context, '/weather-details'),
                  ),

                  // Quick actions
                  QuickActionsWidget(
                    onCameraPressed: () => _handleCameraAction(),
                    onWeatherAlertPressed: () => _handleWeatherAction(),
                    onEmergencyPressed: () => _handleEmergencyAction(),
                  ),

                  SizedBox(height: 2.h),

                  // Today's tasks section
                  _buildSectionHeader(
                    context,
                    'Tâches d\'Aujourd\'hui',
                    'tasks',
                    onSeeAll: () => _showAllTasks(),
                  ),

                  SizedBox(height: 1.h),

                  // Tasks list
                  ..._farmingTasks.take(3).map(
                        (task) => FarmingTaskCardWidget(
                          task: task,
                          onTaskToggle: _handleTaskToggle,
                          onTaskPostpone: _handleTaskPostpone,
                        ),
                      ),

                  SizedBox(height: 2.h),

                  // Crop health section
                  _buildSectionHeader(
                    context,
                    'État de Santé des Cultures',
                    'eco',
                    onSeeAll: () =>
                        Navigator.pushNamed(context, '/crop-health'),
                  ),

                  SizedBox(height: 1.h),

                  // Crop health horizontal list
                  SizedBox(
                    height: 35.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _cropHealthData.length,
                      itemBuilder: (context, index) {
                        return CropHealthCardWidget(
                          cropData: _cropHealthData[index],
                          onTap: () => _showCropDetails(_cropHealthData[index]),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Seasonal recommendations
                  SeasonalRecommendationsWidget(
                    recommendations: _seasonalRecommendations,
                    onSeeAll: () =>
                        Navigator.pushNamed(context, '/recommendations'),
                  ),

                  SizedBox(height: 10.h), // Space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AgroSmart Cameroun',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Dernière mise à jour: ${_formatLastUpdated()}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () => _showNotifications(),
              icon: CustomIconWidget(
                iconName: 'notifications',
                color: Colors.white,
                size: 24,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppTheme.errorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '3',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/user-profile'),
          icon: CustomIconWidget(
            iconName: 'account_circle',
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineIndicator() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(2.w),
        color: AppTheme.warningLight,
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'wifi_off',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Mode hors ligne - Données mises en cache',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String icon, {
    VoidCallback? onSeeAll,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'Voir tout',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: FloatingActionButton(
            onPressed: _handleCameraAction,
            child: CustomIconWidget(
              iconName: 'camera_alt',
              color: Colors.white,
              size: 28,
            ),
            tooltip: 'Analyser une plante',
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    final theme = Theme.of(context);

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 8.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(0, 'home', 'Accueil'),
            _buildBottomNavItem(1, 'eco', 'Cultures'),
            SizedBox(width: 10.w), // Space for FAB
            _buildBottomNavItem(2, 'forum', 'Communauté'),
            _buildBottomNavItem(3, 'person', 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, String icon, String label) {
    final theme = Theme.of(context);
    final isSelected = _currentBottomNavIndex == index;

    return GestureDetector(
      onTap: () => _handleBottomNavTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6) ??
                    Colors.grey,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  // Event handlers
  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _lastUpdated = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Données mises à jour'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTaskToggle(String taskId, bool completed) {
    setState(() {
      final taskIndex =
          _farmingTasks.indexWhere((task) => task["id"] == taskId);
      if (taskIndex != -1) {
        _farmingTasks[taskIndex]["completed"] = completed;
      }
    });
  }

  void _handleTaskPostpone(String taskId) {
    // Handle task postponement logic
  }

  void _handleCameraAction() {
    Navigator.pushNamed(context, '/camera-analysis');
  }

  void _handleWeatherAction() {
    Navigator.pushNamed(context, '/weather-details');
  }

  void _handleEmergencyAction() {
    // Show emergency dialog
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/crop-database');
        break;
      case 2:
        Navigator.pushNamed(context, '/community-forum');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  void _showAllTasks() {
    Navigator.pushNamed(context, '/tasks');
  }

  void _showCropDetails(Map<String, dynamic> cropData) {
    Navigator.pushNamed(context, '/crop-details', arguments: cropData);
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'wb_sunny',
                color: Colors.orange,
                size: 24,
              ),
              title: Text('Alerte Météo'),
              subtitle: Text('Forte chaleur prévue aujourd\'hui'),
              trailing: Text('Il y a 1h'),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'water_drop',
                color: Colors.blue,
                size: 24,
              ),
              title: Text('Rappel d\'Irrigation'),
              subtitle: Text('Il est temps d\'arroser vos tomates'),
              trailing: Text('Il y a 2h'),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bug_report',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text('Alerte Parasites'),
              subtitle: Text('Pucerons détectés dans votre région'),
              trailing: Text('Hier'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return 'Il y a ${difference.inDays}j';
    }
  }
}
