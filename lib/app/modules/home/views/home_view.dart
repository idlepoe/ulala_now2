import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/home/controllers/home_controller.dart';

import '../../../data/utils/logger.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../session/widgets/session_loading_view.dart';
import '../widgets/AppInfoDialog.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('울랄라'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: '앱 소개',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AppInfoDialog(),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const SessionLoadingView();
        }

        final sessions = controller.sessionList;
        if (sessions.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchSessionList, // ✅ 새로고침 동작
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), // ✅ pull 가능하게
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height * 0.8, // 화면 중간 위치 정렬용
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('참여 가능한 세션이 없습니다.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => controller.openCreateSessionSheet(context),
                          child: const Text('세션 만들기'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchSessionList,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return ListTile(
                title: Text(session.name),
                subtitle: Text('참여자 수: ${session.participantCount}'),
                onTap: () => controller.joinSession(session.id),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openCreateSessionSheet(context),
        child: const Icon(Icons.add),
        tooltip: '세션 만들기',
      ),
    );
  }
}
