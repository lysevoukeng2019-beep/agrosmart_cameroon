import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/my_crops_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/offline_data_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _imagePicker = ImagePicker();

  // User data
  String _userName = 'Jean Baptiste Mbarga';
  String _userLocation = 'Yaoundé, Centre, Cameroun';
  String _experienceLevel = 'Agriculteur expérimenté (8 ans)';
  String? _avatarUrl;
  String _selectedLanguage = 'fr';

  // Expanded sections state
  Map<String, bool> _expandedSections = {
    'personal': false,
    'preferences': false,
    'notifications': false,
    'offline': false,
    'help': false,
  };

  // Notification settings
  Map<String, bool> _notificationSettings = {
    'weather_alerts': true,
    'crop_reminders': true,
    'community_updates': false,
    'expert_advice': true,
  };

  // Offline data
  double _storageUsed = 45.2;
  double _totalStorage = 100.0;
  DateTime? _lastSyncTime = DateTime.now().subtract(Duration(hours: 2));
  bool _isSyncing = false;

  // Mock data
  final List<Map<String, dynamic>> _mockCrops = [
    {
      "id": 1,
      "name": "Maïs",
      "image":
          "https://images.pexels.com/photos/547263/pexels-photo-547263.jpeg",
      "plantedDate": "15/03/2024",
      "location": "Champ Nord",
      "healthStatus": "excellent",
    },
    {
      "id": 2,
      "name": "Tomate",
      "image":
          "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg",
      "plantedDate": "20/02/2024",
      "location": "Serre 1",
      "healthStatus": "bon",
    },
    {
      "id": 3,
      "name": "Manioc",
      "image":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg",
      "plantedDate": "10/01/2024",
      "location": "Champ Sud",
      "healthStatus": "moyen",
    },
  ];

  final List<Map<String, dynamic>> _mockAchievements = [
    {
      "id": 1,
      "title": "Premier pas",
      "description": "Première culture ajoutée",
      "icon": "eco",
      "type": "farming",
      "unlocked": true,
    },
    {
      "id": 2,
      "title": "Communauté",
      "description": "10 messages postés",
      "icon": "forum",
      "type": "community",
      "unlocked": true,
    },
    {
      "id": 3,
      "title": "Assidu",
      "description": "7 jours consécutifs",
      "icon": "calendar_today",
      "type": "usage",
      "unlocked": false,
    },
    {
      "id": 4,
      "title": "Expert",
      "description": "50 analyses réalisées",
      "icon": "analytics",
      "type": "milestone",
      "unlocked": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Mon Profil',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showSettingsMenu,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            // Profile Header
            ProfileHeaderWidget(
              userName: _userName,
              location: _userLocation,
              experienceLevel: _experienceLevel,
              avatarUrl: _avatarUrl,
              onEditPressed: _showEditProfileDialog,
              onAvatarPressed: _showImagePicker,
            ),
            SizedBox(height: 3.h),

            // My Crops Section
            MyCropsWidget(
              crops: _mockCrops,
              onCropTapped: _onCropTapped,
            ),
            SizedBox(height: 3.h),

            // Profile Sections
            ProfileSectionWidget(
              title: 'Informations personnelles',
              iconName: 'person',
              isExpanded: _expandedSections['personal']!,
              onToggle: () => _toggleSection('personal'),
              items: [
                ProfileSectionItem(
                  title: 'Coordonnées',
                  subtitle: 'Email, téléphone, adresse',
                  onTap: () => _showPersonalInfoDialog(),
                ),
                ProfileSectionItem(
                  title: 'Localisation agricole',
                  subtitle: 'Position GPS de vos champs',
                  onTap: () => _showLocationSelector(),
                ),
                ProfileSectionItem(
                  title: 'Cultures principales',
                  subtitle: 'Types de cultures que vous cultivez',
                  onTap: () => _showCropSelector(),
                ),
                ProfileSectionItem(
                  title: 'Méthodes agricoles',
                  subtitle: 'Traditionnelle, biologique, mixte',
                  onTap: () => _showFarmingMethodsDialog(),
                ),
              ],
            ),

            // Language Preferences
            ProfileSectionWidget(
              title: 'Préférences linguistiques',
              iconName: 'language',
              isExpanded: _expandedSections['preferences']!,
              onToggle: () => _toggleSection('preferences'),
              items: [
                ProfileSectionItem(
                  title: 'Langue de l\'interface',
                  subtitle: _getLanguageName(_selectedLanguage),
                  onTap: () => _showLanguageSelector(),
                ),
              ],
            ),

            // Notification Settings
            ProfileSectionWidget(
              title: 'Paramètres de notification',
              iconName: 'notifications',
              isExpanded: _expandedSections['notifications']!,
              onToggle: () => _toggleSection('notifications'),
              items: [
                ProfileSectionItem(
                  title: 'Gérer les notifications',
                  subtitle: 'Configurer les alertes et rappels',
                  onTap: () => _showNotificationSettings(),
                ),
              ],
            ),

            // Offline Data Management
            ProfileSectionWidget(
              title: 'Gestion des données hors ligne',
              iconName: 'cloud_download',
              isExpanded: _expandedSections['offline']!,
              onToggle: () => _toggleSection('offline'),
              items: [
                ProfileSectionItem(
                  title: 'Stockage et synchronisation',
                  subtitle: 'Gérer les données locales',
                  onTap: () => _showOfflineDataManager(),
                ),
              ],
            ),

            // Help & Support
            ProfileSectionWidget(
              title: 'Aide et support',
              iconName: 'help',
              isExpanded: _expandedSections['help']!,
              onToggle: () => _toggleSection('help'),
              items: [
                ProfileSectionItem(
                  title: 'Guide d\'utilisation',
                  subtitle: 'Comment utiliser l\'application',
                  onTap: () => _showUserGuide(),
                ),
                ProfileSectionItem(
                  title: 'Contacter le support',
                  subtitle: 'Obtenir de l\'aide technique',
                  onTap: () => _contactSupport(),
                ),
                ProfileSectionItem(
                  title: 'À propos',
                  subtitle: 'Version ${_getAppVersion()}',
                  onTap: () => _showAboutDialog(),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Achievement Badges
            AchievementBadgeWidget(
              achievements: _mockAchievements,
            ),
            SizedBox(height: 4.h),

            // Logout Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showLogoutConfirmation,
                icon: CustomIconWidget(
                  iconName: 'logout',
                  color: AppTheme.errorLight,
                  size: 5.w,
                ),
                label: Text('Se déconnecter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorLight,
                  side: BorderSide(color: AppTheme.errorLight),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSections[section] = !_expandedSections[section]!;
    });
  }

  void _onCropTapped(Map<String, dynamic> crop) {
    Navigator.pushNamed(context, '/crop-database');
  }

  Future<void> _showImagePicker() async {
    final hasPermission = await _requestCameraPermission();
    if (!hasPermission) {
      _showPermissionDeniedDialog();
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Changer la photo de profil',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  'Caméra',
                  'camera_alt',
                  () => _pickImage(ImageSource.camera),
                ),
                _buildImagePickerOption(
                  'Galerie',
                  'photo_library',
                  () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption(
      String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _avatarUrl = image.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo de profil mise à jour'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection de l\'image'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission requise'),
        content: Text(
            'L\'accès à la caméra est nécessaire pour changer votre photo de profil.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Paramètres'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final locationController = TextEditingController(text: _userLocation);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom complet',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Localisation',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text;
                _userLocation = locationController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profil mis à jour')),
              );
            },
            child: Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => LanguageSelectorWidget(
        selectedLanguage: _selectedLanguage,
        onLanguageChanged: (language) {
          setState(() {
            _selectedLanguage = language;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Langue mise à jour')),
          );
        },
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => NotificationSettingsWidget(
        notificationSettings: _notificationSettings,
        onSettingChanged: (key, value) {
          setState(() {
            _notificationSettings[key] = value;
          });
        },
      ),
    );
  }

  void _showOfflineDataManager() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => OfflineDataWidget(
        storageUsed: _storageUsed,
        totalStorage: _totalStorage,
        lastSyncTime: _lastSyncTime,
        isSyncing: _isSyncing,
        onSyncPressed: _performSync,
        onClearCachePressed: _clearCache,
      ),
    );
  }

  void _performSync() {
    setState(() {
      _isSyncing = true;
    });

    // Simulate sync process
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isSyncing = false;
        _lastSyncTime = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Synchronisation terminée'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    });
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vider le cache'),
        content: Text(
            'Cette action supprimera toutes les données mises en cache. Continuer ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _storageUsed = 5.0;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cache vidé avec succès'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Vider'),
          ),
        ],
      ),
    );
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Paramètres',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'backup',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Exporter les données'),
              subtitle: Text('Sauvegarder vos données agricoles'),
              onTap: () {
                Navigator.pop(context);
                _exportData();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Confidentialité'),
              subtitle: Text('Gérer vos données personnelles'),
              onTap: () {
                Navigator.pop(context);
                _showPrivacySettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export des données en cours...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Paramètres de confidentialité')),
    );
  }

  void _showPersonalInfoDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gestion des informations personnelles')),
    );
  }

  void _showLocationSelector() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sélecteur de localisation GPS')),
    );
  }

  void _showCropSelector() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sélection des cultures principales')),
    );
  }

  void _showFarmingMethodsDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuration des méthodes agricoles')),
    );
  }

  void _showUserGuide() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Guide d\'utilisation')),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact du support technique')),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('À propos d\'AgroSmart Cameroun'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: ${_getAppVersion()}'),
            SizedBox(height: 1.h),
            Text(
                'Application d\'assistance agricole pour les agriculteurs camerounais.'),
            SizedBox(height: 2.h),
            Text('Développé avec ❤️ pour l\'agriculture durable au Cameroun.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Se déconnecter'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'fr':
        return 'Français';
      case 'ff':
        return 'Fulfulde';
      case 'ew':
        return 'Ewondo';
      case 'du':
        return 'Duala';
      default:
        return 'Français';
    }
  }

  String _getAppVersion() {
    return '1.0.0';
  }
}
