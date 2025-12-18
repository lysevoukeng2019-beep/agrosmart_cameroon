import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreatePostSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostCreated;

  const CreatePostSheet({
    super.key,
    required this.onPostCreated,
  });

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  XFile? _selectedImage;
  String? _recordingPath;
  bool _isRecording = false;
  bool _isCameraInitialized = false;
  String _selectedCrop = 'Maïs';

  final List<String> _cropOptions = [
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
    'Palmier à huile',
    'Ananas'
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    if (!await _requestCameraPermission()) return;

    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final camera = kIsWeb
            ? _cameras!.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
                orElse: () => _cameras!.first,
              )
            : _cameras!.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.back,
                orElse: () => _cameras!.first,
              );

        _cameraController = CameraController(
          camera,
          kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        );

        await _cameraController!.initialize();
        await _applySettings();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _selectedImage = photo;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  Future<void> _startRecording() async {
    if (!await _audioRecorder.hasPermission()) {
      return;
    }

    try {
      if (kIsWeb) {
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: 'recording.wav',
        );
      } else {
        await _audioRecorder.start(
          const RecordConfig(),
          path: 'recording.wav',
        );
      }

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      debugPrint('Recording start error: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
    } catch (e) {
      debugPrint('Recording stop error: $e');
    }
  }

  void _createPost() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir le titre et le contenu'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final post = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'author': 'Utilisateur Actuel',
      'location': 'Yaoundé, Cameroun',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'cropTag': _selectedCrop,
      'timestamp': DateTime.now(),
      'imageUrl': _selectedImage?.path,
      'hasVoiceNote': _recordingPath != null,
      'voiceNotePath': _recordingPath,
      'likeCount': 0,
      'replyCount': 0,
      'shareCount': 0,
      'isLiked': false,
      'isExpert': false,
    };

    widget.onPostCreated(post);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCropSelector(theme),
                  SizedBox(height: 3.h),
                  _buildTitleField(theme),
                  SizedBox(height: 2.h),
                  _buildContentField(theme),
                  SizedBox(height: 3.h),
                  _buildMediaSection(theme),
                  SizedBox(height: 3.h),
                  _buildVoiceSection(theme),
                ],
              ),
            ),
          ),
          _buildBottomActions(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              'Créer une publication',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: _createPost,
            child: Text(
              'Publier',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Culture concernée',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCrop,
              isExpanded: true,
              items: _cropOptions.map((crop) {
                return DropdownMenuItem<String>(
                  value: crop,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'eco',
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 3.w),
                      Text(crop),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCrop = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Titre',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Quel est votre sujet ?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildContentField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _contentController,
          decoration: InputDecoration(
            hintText: 'Décrivez votre question ou partagez votre expérience...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildMediaSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ajouter une photo',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        if (_selectedImage != null) ...[
          Container(
            height: 25.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: kIsWeb
                  ? Image.network(
                      _selectedImage!.path,
                      fit: BoxFit.cover,
                    )
                  : CustomImageWidget(
                      imageUrl: _selectedImage!.path,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'delete',
                  size: 20,
                  color: theme.colorScheme.error,
                ),
                label: Text(
                  'Supprimer',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isCameraInitialized ? _capturePhoto : null,
                  icon: CustomIconWidget(
                    iconName: 'camera_alt',
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text('Appareil photo'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: CustomIconWidget(
                    iconName: 'photo_library',
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text('Galerie'),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildVoiceSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message vocal',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        if (_recordingPath != null) ...[
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'mic',
                  size: 24,
                  color: theme.colorScheme.secondary,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Message vocal enregistré',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _recordingPath = null;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          GestureDetector(
            onTapDown: (_) => _startRecording(),
            onTapUp: (_) => _stopRecording(),
            onTapCancel: () => _stopRecording(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 3.h),
              decoration: BoxDecoration(
                color: _isRecording
                    ? theme.colorScheme.error.withValues(alpha: 0.1)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isRecording
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: _isRecording ? 'stop' : 'mic',
                    size: 32,
                    color: _isRecording
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _isRecording
                        ? 'Relâchez pour arrêter'
                        : 'Maintenez pour enregistrer',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _isRecording
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Annuler'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _createPost,
                child: Text('Publier'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}