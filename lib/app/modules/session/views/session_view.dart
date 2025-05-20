import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/session_controller.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final session = controller.session.value;

      if (session == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(session.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "트랙 추가",
              onPressed: () => _openTrackSearchSheet(context),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            if (session.trackList.isEmpty) ...[
              Expanded(
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("재생할 음악 트랙 추가하기"),
                    onPressed: () => _openTrackSearchSheet(context),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: session.trackList.length,
                  itemBuilder: (context, index) {
                    final track = session.trackList[index];
                    return ListTile(
                      leading: Image.network(track.thumbnail, width: 50),
                      title: Text(track.title),
                      subtitle: Text("추가한 사람: ${track.addedBy.nickname}"),
                    );
                  },
                ),
              ),
            ],
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                children:
                    session.participants.map((p) {
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundImage: NetworkImage(p.avatarUrl),
                        ),
                        label: Text(p.nickname),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _openTrackSearchSheet(BuildContext context) {
    final controller = Get.find<SessionController>();
    final searchController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Text("YouTube에서 트랙 검색", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "노래 제목 또는 아티스트 입력",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final keyword = searchController.text.trim();
                    if (keyword.isNotEmpty) {
                      controller.searchYoutube(keyword);
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.searchYoutube(value.trim());
                }
              },
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isSearching.value) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final results = controller.youtubeSearchResults;
              if (results.isEmpty) {
                return const Expanded(
                  child: Center(child: Text("검색 결과가 없습니다.")),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return ListTile(
                      leading: Image.network(
                        item.snippet.thumbnails.medium.url,
                        width: 60,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        item.snippet.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(item.snippet.description),
                      onTap: () {
                        // 여기에 track 추가 처리 (예: addTrack API 호출)
                        // 예: controller.addTrackFromYoutubeItem(item);
                        Get.back(); // 닫기
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
