import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/router/routes.dart';
import 'package:tasksphere/core/utils/app_utils.dart';
import 'package:tasksphere/core/widgets/layouts/scaffold_layout.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';
import 'package:tasksphere/features/home/presentation/widgets/profile_avatar.dart';
import 'package:tasksphere/features/home/presentation/widgets/profile_field.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _pickedImage;
  bool _hasChanges = false;
  bool _isSaving = false;
  bool _hasEmailChange = false;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authProvider).asData?.value.user;
    _nameController.text = user?.name ?? '';

    _emailController.text = user?.email ?? '';

    _nameController.addListener(_handleInputChanged);
    _emailController.addListener(_handleInputChanged);

    if (_hasChanges) {
      _saveProfile(isAuthenticated: true);
    }
  }

  void _handleInputChanged() {
    final user = ref.read(authProvider).asData?.value.user;
    final hasFieldChanges =
        user != null &&
        (_nameController.text.trim() != user.name ||
            _emailController.text.trim() != user.email);

    final hasChanges = hasFieldChanges || _pickedImage != null;

    setState(() {
      _hasEmailChange =
          user != null && _emailController.text.trim() != user.email;
    });

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 900,
    );
    if (picked == null) return;

    setState(() {
      _pickedImage = picked;
      _hasChanges = true;
    });
  }

  Future<void> _showImageSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile({bool isAuthenticated = false}) async {
    if (!_formKey.currentState!.validate()) return;

    if (!isAuthenticated && _hasEmailChange) {
      final result = await context.pushNamed(RouteNames.reAuth);
      if (result != true) return;
    }

    setState(() {
      _isSaving = true;
    });
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();

    final authActions = ref.read(authProvider.notifier);
    final user = ref.read(authProvider).asData?.value.user;

    await authActions.updateProfile(
      name: name.isEmpty || name == user?.name ? null : name,
      email: email.isEmpty || email == user?.email ? null : email,
      img: _pickedImage,
    );

    setState(() {
      _isSaving = false;
      _hasChanges = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleInputChanged);
    _emailController.removeListener(_handleInputChanged);
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!AppUtils.isValidEmail(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final auth = ref.watch(authProvider).asData?.value;
    final user = auth?.user;
    final avatarUrl = _pickedImage != null ? _pickedImage!.path : user?.imgUrl;
    final name = user?.name ?? 'User';
    final provider = auth?.provider ?? 'Email';

    return ScaffoldLayout(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyMedium?.color,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _hasChanges
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FloatingActionButton.extended(
                  onPressed: _isSaving ? null : () => _saveProfile(),
                  backgroundColor: _isSaving
                      ? Colors.grey
                      : AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  label: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Update Profile'),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: Column(
          children: [
            ProfileAvatar(
              name: name,
              imageUrl: avatarUrl,
              imageProvider: _pickedImage != null
                  ? FileImage(File(_pickedImage!.path))
                  : null,
              borderColor: AppConstants.primaryColor,
              onEdit: _showImageSourceSheet,
            ),

            const SizedBox(height: 30),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileField(
                        controller: _nameController,
                        label: 'Full name',
                        hintText: 'Enter your full name',
                        icon: Icons.person_outline,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 14),
                      provider != 'google.com'
                          ? ProfileField(
                              controller: _emailController,
                              label: 'Email',
                              hintText: 'Enter your email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                            )
                          : SizedBox.shrink(),

                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
