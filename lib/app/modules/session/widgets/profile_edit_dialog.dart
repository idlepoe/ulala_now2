import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ulala_now2/app/modules/session/controllers/session_controller.dart';

import '../../../data/utils/api_service.dart';

class ProfileEditDialog extends StatefulWidget {
  const ProfileEditDialog({super.key});

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final TextEditingController nicknameController = TextEditingController();
  String? imageUrl;
  bool isSaving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    nicknameController.text = user?.displayName ?? '';
    imageUrl = user?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('edit_profile'.tr),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl!) : null,
                child:
                    imageUrl == null
                        ? const Icon(Icons.camera_alt, size: 32)
                        : null,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nicknameController,
              decoration: InputDecoration(
                labelText: 'nickname'.tr,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'nickname_required'.tr;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _saveProfile,
          child:
              isSaving
                  ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text('save'.tr),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final uploadedUrl = await ApiService.uploadFileToStorage(xFile: picked);
      setState(() {
        imageUrl = uploadedUrl;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    final nickname = nicknameController.text.trim();

    if (user == null) return;

    setState(() => isSaving = true);

    try {
      await user.updateDisplayName(nickname);
      if (imageUrl != null) {
        await user.updatePhotoURL(imageUrl);
      }
      await user.reload();

      joinSession(Get.find<SessionController>().sessionId);

      Get.snackbar('edit_profile'.tr, 'profile_updated'.tr);
      Navigator.pop(context, true); // ✅ true 반환
    } catch (e) {
      Get.snackbar('오류', 'profile_update_failed'.tr);
    } finally {
      setState(() => isSaving = false);
    }
  }

  void joinSession(String sessionId) async {
    try {
      await ApiService.joinSession(sessionId);
    } catch (e) {
      Get.snackbar('error'.tr, 'session_join_failed'.tr);
    }
  }
}
