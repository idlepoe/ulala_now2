import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoButtonYoutubeQuota extends StatelessWidget {
  const InfoButtonYoutubeQuota({super.key});

  @override
  Widget build(BuildContext context) {
    String youtubeQuotaNotice = 'youtube_quota_notice_desc'.tr;

    return IconButton(
      icon: const Icon(Icons.info_outline, color: Colors.grey),
      tooltip: 'youtube_quota_notice_title'.tr,
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('youtube_quota_notice_title'.tr),
                content: SingleChildScrollView(
                  child: Text(
                    youtubeQuotaNotice,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('confirm'.tr),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );
      },
    );
  }
}
