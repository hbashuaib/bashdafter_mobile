import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

import '../services/profile_service.dart';
import '../../auth/models/user_profile.dart';
import '../services/profile_image_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? profile;

  bool isLoading = true;
  bool isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await ProfileService().getProfile();

      if (!mounted) return;

      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.failedToLoadProfile)));

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      debugPrint('IMAGE PATH: ${image.path}');

      setState(() {
        isUploadingImage = true;
      });

      await ProfileImageService().uploadImage(image.path);
      await loadProfile();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.profileImageUpdated)));
    } catch (e) {
      debugPrint('IMAGE UPLOAD ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.failedToUploadImage)));
    } finally {
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.profile)),
        body: Center(child: Text(context.l10n.noProfileFound)),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile)),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

        children: [
          Card(
            color: AppColors.cardTint(context, Colors.blue.shade50),

            child: Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                children: [
                  Text(
                    context.l10n.profileInformation,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 6),

                  Text(context.l10n.profileInformationDescription),
                ],
              ),
            ),
          ),

          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: profile!.profileImage.isNotEmpty
                      ? NetworkImage(profile!.profileImage)
                      : null,

                  child: profile!.profileImage.isEmpty
                      ? const Icon(Icons.person, size: 55, color: Colors.white)
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,

                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue,

                    child: isUploadingImage
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),

                            onPressed: () {
                              if (kIsWeb) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context
                                          .l10n
                                          .profileImageUploadUnsupported,
                                    ),
                                  ),
                                );

                                return;
                              }

                              pickImage();
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            profile!.fullName,
            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            profile!.role.isEmpty ? context.l10n.user : profile!.role,
            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(context.l10n.user),
              subtitle: Text(profile!.fullName),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.store, color: Colors.green),
              title: Text(context.l10n.application),
              subtitle: Text(context.l10n.applicationName),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.orange),
              title: Text(context.l10n.role),
              subtitle: Text(
                profile!.role.isEmpty ? context.l10n.user : profile!.role,
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.alternate_email, color: Colors.cyan),
              title: Text(context.l10n.username),
              subtitle: Text(profile!.username),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: Text(context.l10n.email),

              subtitle: Text(
                profile!.email.trim().isNotEmpty ? profile!.email : '-',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text(context.l10n.phoneNumber),
              subtitle: Text(
                profile!.phoneNumber.trim().isNotEmpty
                    ? profile!.phoneNumber
                    : '-',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.color_lens, color: Colors.purple),
              title: Text(context.l10n.theme),
              subtitle: Text(
                isDarkMode ? context.l10n.darkMode : context.l10n.lightMode,
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.teal),
              title: Text(context.l10n.version),
              subtitle: const Text('1.0.0'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.indigo),
              title: Text(context.l10n.company),
              subtitle: Text(context.l10n.companyName),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_reset, color: Colors.indigo),

              title: Text(context.l10n.changePassword),
              subtitle: Text(context.l10n.updateYourAccountPassword),
              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
