import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../main.dart';
import 'detail_page.dart';

// Halaman beranda: grid daftar anime dari API Kitsu.
// State (loading/error/data) ada di HomeController (GetX), UI hanya membaca.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keripikroll'),
        centerTitle: false,
        actions: [
          // Menu sort: mengubah c.sortMode, grid otomatis terurut ulang.
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => c.sortMode.value = v,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'default', child: Text('Default')),
              PopupMenuItem(value: 'rating', child: Text('Rating tertinggi')),
              PopupMenuItem(value: 'name', child: Text('Nama A-Z')),
            ],
          ),
        ],
      ),
      body: Column(children: [
        // Kolom search: tiap ketikan mengubah c.query, grid langsung terfilter.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            onChanged: (v) => c.query.value = v,
            decoration: InputDecoration(
              hintText: 'Cari anime...',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey)),
            ),
          ),
        ),
        Expanded(child: _body(c)),
      ]),
    );
  }

  // Obx rebuild otomatis saat loading / error / shows / query / sortMode berubah.
  Widget _body(HomeController c) => Obx(() {
        // Loading indicator selama data diambil.
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator(color: kRed));
        }
        // Error (mis. tidak ada internet): pesan + tombol coba lagi.
        if (c.error.value != null) {
          return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(c.error.value!),
            TextButton(onPressed: c.fetch, child: const Text('Coba lagi')),
          ]));
        }
        // filtered = shows setelah search dan sort (lihat HomeController).
        final shows = c.filtered;
        if (shows.isEmpty) return const Center(child: Text('Tidak ada hasil'));
        // Grid 2 kolom; GridView.builder hanya membangun item yang terlihat.
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62, // rasio lebar:tinggi kartu
              crossAxisSpacing: 16,
              mainAxisSpacing: 16),
          itemCount: shows.length,
          itemBuilder: (_, i) {
            final a = shows[i]['attributes'];
            return _ShowCard(
              id: shows[i]['id'],
              name: a['titles']?['en_jp'] ?? a['canonicalTitle'] ?? '-',
              image: a['posterImage']?['small'],
              rating: a['averageRating'],
              age: a['ageRating'],
            );
          },
        );
      });
}

// Satu kartu show: gambar, judul, dan rating. Klik membuka detail.
class _ShowCard extends StatelessWidget {
  final String id;
  final String name;
  final String? image;
  final String? rating;
  final String? age;
  const _ShowCard({required this.id, required this.name, this.image, this.rating, this.age});

  @override
  Widget build(BuildContext context) => GestureDetector(
        // Get.to: pindah halaman tanpa BuildContext.
        onTap: () => Get.to(() => DetailPage(id: id)),
        child: Container(
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(18)),
          clipBehavior: Clip.antiAlias, // potong gambar mengikuti sudut bulat
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Gambar mengisi sisa ruang di atas teks.
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: image == null
                    ? const Icon(Icons.image_not_supported, size: 48)
                    : Image.network(image!, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(rating ?? '-'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(age ?? '-', style: const TextStyle(fontSize: 11)),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      );
}
