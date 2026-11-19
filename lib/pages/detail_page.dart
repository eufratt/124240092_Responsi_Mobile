import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_controller.dart';
import '../main.dart';
import '../services/favorite_service.dart';
import '../services/notification_service.dart';

// Halaman detail satu show. State ada di DetailController (GetX).
class DetailPage extends StatelessWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // tag = id supaya tiap show punya controller sendiri (tidak tertukar).
    final c = Get.put(DetailController(id), tag: '$id');
    return Scaffold(
      // AppBar otomatis punya tombol kembali ke halaman sebelumnya.
      appBar: AppBar(title: const Text('Detail')),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator(color: kRed));
        }
        if (c.error.value != null) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(c.error.value!),
            TextButton(onPressed: c.fetch, child: const Text('Coba lagi')),
          ]));
        }
        final a = c.show.value!['attributes'];
        final title = (a['titles']?['en_jp'] ?? a['canonicalTitle'] ?? '-').toString();
        // Cover bisa null di beberapa anime; cadangannya poster.
        final image = a['coverImage']?['small'] ?? a['posterImage']?['small'];
        final poster = a['posterImage']?['small'];
        final rating = a['averageRating'] as String?;
        final info = '${a['ageRating'] ?? '-'}  •  ${a['episodeCount'] ?? '?'} episode';
        final summary = (a['synopsis'] ?? '').toString();
        return ListView(children: [
          if (image != null)
            Hero(
              tag: 'anime-$id',
              child: Image.network(image, width: double.infinity, height: 240, fit: BoxFit.cover),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 6),
                Text(rating?.toString() ?? '-', style: const TextStyle(fontSize: 16)),
              ]),
              const SizedBox(height: 8),
              Text(info,
                  style: const TextStyle(color: Colors.white70, fontSize: 15)),
              const SizedBox(height: 16),
              Row(children: [
                // Tombol "Nonton": hanya menampilkan snackbar (tidak ada player).
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () => Get.snackbar('Nonton', 'Memutar $title...',
                        snackPosition: SnackPosition.BOTTOM),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Nonton'),
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol favorit; rebuild otomatis saat box Hive berubah.
                ValueListenableBuilder(
                  valueListenable: FavoriteService.listenable(),
                  builder: (_, _, _) {
                    final fav = FavoriteService.isFav(id);
                    return Material(
                      color: kCard,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          final wasFav = FavoriteService.isFav(id);
                          await FavoriteService.toggle(
                              id, title, poster, rating);
                          NotificationService.show(
                              wasFav ? 'Dihapus dari favorit' : 'Ditambahkan ke favorit',
                              title);
                        },
                        child: SizedBox(
                          width: 52,
                          height: 52,
                          child: Icon(fav ? Icons.favorite : Icons.favorite_border,
                              color: fav ? kRed : Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24),
              const Text('Sinopsis',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(summary, style: const TextStyle(fontSize: 16, height: 1.5)),
            ]),
          ),
        ]);
      }),
    );
  }
}
