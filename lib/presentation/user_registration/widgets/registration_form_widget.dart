import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormSubmit;
  final bool isLoading;

  const RegistrationFormWidget({
    super.key,
    required this.onFormSubmit,
    required this.isLoading,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String _selectedLanguage = 'Français';
  List<String> _selectedCrops = [];
  bool _acceptTerms = false;
  double _passwordStrength = 0.0;

  final List<String> _languages = [
    'Français',
    'Fulfulde',
    'Ewondo',
    'Duala',
  ];

  final List<String> _crops = [
    'Maïs',
    'Manioc',
    'Arachide',
    'Cacao',
    'Café',
    'Banane Plantain',
    'Igname',
    'Riz',
    'Tomate',
    'Haricot',
    'Palmier à Huile',
    'Ananas',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    double strength = 0.0;

    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    setState(() {
      _passwordStrength = strength;
    });
  }

  Color _getPasswordStrengthColor() {
    if (_passwordStrength <= 0.25) return Colors.red;
    if (_passwordStrength <= 0.5) return Colors.orange;
    if (_passwordStrength <= 0.75) return Colors.yellow;
    return AppTheme.successLight;
  }

  String _getPasswordStrengthText() {
    if (_passwordStrength <= 0.25) return 'Faible';
    if (_passwordStrength <= 0.5) return 'Moyen';
    if (_passwordStrength <= 0.75) return 'Bon';
    return 'Fort';
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true &&
        _selectedCrops.isNotEmpty &&
        _acceptTerms &&
        _passwordStrength >= 0.5;
  }

  void _submitForm() {
    if (_isFormValid()) {
      final formData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
        'language': _selectedLanguage,
        'crops': _selectedCrops,
        'password': _passwordController.text,
      };
      widget.onFormSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameField(),
          SizedBox(height: 3.h),
          _buildPhoneField(),
          SizedBox(height: 3.h),
          _buildLocationField(),
          SizedBox(height: 3.h),
          _buildLanguageSelector(),
          SizedBox(height: 3.h),
          _buildCropsSelector(),
          SizedBox(height: 3.h),
          _buildPasswordField(),
          SizedBox(height: 2.h),
          _buildPasswordStrengthIndicator(),
          SizedBox(height: 3.h),
          _buildTermsCheckbox(),
          SizedBox(height: 4.h),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nom complet',
        hintText: 'Entrez votre nom complet',
        prefixIcon: Padding(
          padding: EdgeInsets.all(12),
          child: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Le nom est requis';
        }
        if (value.trim().length < 2) {
          return 'Le nom doit contenir au moins 2 caractères';
        }
        return null;
      },
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone',
        hintText: '+237 6XX XXX XXX',
        prefixIcon: Padding(
          padding: EdgeInsets.all(12),
          child: CustomIconWidget(
            iconName: 'phone',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Le numéro de téléphone est requis';
        }
        if (value.length < 9) {
          return 'Numéro de téléphone invalide';
        }
        return null;
      },
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Localisation',
        hintText: 'Ville, Région',
        prefixIcon: Padding(
          padding: EdgeInsets.all(12),
          child: CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            // GPS location functionality would be implemented here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Localisation GPS non disponible hors ligne'),
                backgroundColor: AppTheme.warningLight,
              ),
            );
          },
          icon: CustomIconWidget(
            iconName: 'gps_fixed',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'La localisation est requise';
        }
        return null;
      },
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Langue préférée',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimaryLight,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              items: _languages.map((language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCropsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cultures principales',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimaryLight,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: 20.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: _crops.map((crop) {
                final isSelected = _selectedCrops.contains(crop);
                return CheckboxListTile(
                  title: Text(crop),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCrops.add(crop);
                      } else {
                        _selectedCrops.remove(crop);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                );
              }).toList(),
            ),
          ),
        ),
        if (_selectedCrops.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: Text(
              'Sélectionnez au moins une culture',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        hintText: 'Créez un mot de passe sécurisé',
        prefixIcon: Padding(
          padding: EdgeInsets.all(12),
          child: CustomIconWidget(
            iconName: 'lock',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: CustomIconWidget(
            iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
            color: AppTheme.textSecondaryLight,
            size: 20,
          ),
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Le mot de passe est requis';
        }
        if (value.length < 8) {
          return 'Le mot de passe doit contenir au moins 8 caractères';
        }
        return null;
      },
      onChanged: (value) {
        _calculatePasswordStrength(value);
        setState(() {});
      },
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Force du mot de passe: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              _getPasswordStrengthText(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getPasswordStrengthColor(),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor: AppTheme.dividerLight,
          valueColor:
              AlwaysStoppedAnimation<Color>(_getPasswordStrengthColor()),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (bool? value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Text(
              'J\'accepte les conditions d\'utilisation et la politique de confidentialité concernant l\'utilisation des données agricoles et la fonctionnalité hors ligne.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isEnabled = _isFormValid() && !widget.isLoading;

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isEnabled ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.textDisabledLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: widget.isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'Créer un compte',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}
