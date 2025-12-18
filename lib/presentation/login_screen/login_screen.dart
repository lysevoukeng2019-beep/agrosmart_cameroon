import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  String _selectedLanguage = 'fr';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    '677123456': 'farmer123',
    '695987654': 'agro2024',
    '681234567': 'cameroon',
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String phoneNumber, String password) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Check mock credentials
    if (_mockCredentials.containsKey(phoneNumber) &&
        _mockCredentials[phoneNumber] == password) {
      // Success
      HapticFeedback.mediumImpact();
      _showSuccessMessage();

      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } else {
      // Error
      HapticFeedback.heavyImpact();
      _showErrorMessage();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleWhatsAppLogin() {
    Fluttertoast.showToast(
      msg: "Connexion WhatsApp bientôt disponible",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleBiometricLogin() {
    Fluttertoast.showToast(
      msg: "Authentification biométrique en cours...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Simulate biometric authentication
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    });
  }

  void _showSuccessMessage() {
    Fluttertoast.showToast(
      msg: "Connexion réussie! Bienvenue agriculteur",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successLight,
      textColor: Colors.white,
    );
  }

  void _showErrorMessage() {
    Fluttertoast.showToast(
      msg: "Identifiants incorrects. Vérifiez votre numéro et mot de passe",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.errorLight,
      textColor: Colors.white,
    );
  }

  void _handleLanguageChange(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });

    Fluttertoast.showToast(
      msg: "Langue changée",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background with agricultural imagery
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),

            // Language selector at top
            Positioned(
              top: 2.h,
              right: 4.w,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: LanguageSelectorWidget(
                  selectedLanguage: _selectedLanguage,
                  onLanguageChanged: _handleLanguageChange,
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),

                      // App Logo and Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              Container(
                                width: 25.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'eco',
                                    color: theme.colorScheme.onPrimary,
                                    size: 12.w,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'AgroSmart Cameroon',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Votre assistant agricole intelligent',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Login Form
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: LoginFormWidget(
                            onLogin: _handleLogin,
                            isLoading: _isLoading,
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Social Login
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SocialLoginWidget(
                          isLoading: _isLoading,
                          onWhatsAppLogin: _handleWhatsAppLogin,
                        ),
                      ),

                      // Biometric Login
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: BiometricLoginWidget(
                          isAvailable: _isBiometricAvailable,
                          onBiometricLogin: _handleBiometricLogin,
                        ),
                      ),

                      Spacer(),

                      // Register Link
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(3.w),
                            border: Border.all(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'agriculture',
                                    color: theme.colorScheme.primary,
                                    size: 6.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      'Nouveau dans l\'agriculture intelligente?',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              SizedBox(
                                width: double.infinity,
                                height: 6.h,
                                child: OutlinedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          Navigator.pushNamed(
                                              context, '/user-registration');
                                        },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: theme.colorScheme.primary,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                  ),
                                  child: Text(
                                    'Créer un compte agriculteur',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
