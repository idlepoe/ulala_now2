import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ulala_now2/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [const Text('울랄라')]),
        actions: [
          if (user != null)
            Row(
              children: [
                Text(user.displayName ?? '익명'),
                const SizedBox(width: 8),
                if (user.photoURL != null)
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                const SizedBox(width: 8),
              ],
            ),
          IconButton(
            onPressed: () {
              controller.fetchSessionList();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/icon-removebg.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 32),

                // 🔽 고정 안내 문구
                const Text(
                  '세션 상태를 확인하는 중...',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const CircularProgressIndicator(),
              ],
            ),
          );
        }

        final sessions = controller.sessionList;
        if (sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('참여 가능한 세션이 없습니다.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.openCreateSessionSheet(context),
                  child: const Text('세션 만들기'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return ListTile(
              title: Text(session.name),
              subtitle: Text('참여자 수: ${session.participantCount}'),
              onTap: () => controller.joinSession(session.id),
            );
          },
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
