import 'package:flutter/material.dart';

class AgendaCard extends StatelessWidget {
  final String namaKegiatan;
  final String tanggal;
  final String jamAwal;
  final String jamAkhir;
  final String lokasi;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isAdmin;

  const AgendaCard(
      {super.key,
      required this.namaKegiatan,
      required this.tanggal,
      required this.jamAwal,
      required this.jamAkhir,
      required this.lokasi,
      required this.onEdit,
      required this.onDelete,
      this.isAdmin = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  namaKegiatan,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$jamAwal – $jamAkhir',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              tanggal,
              style: TextStyle(
                  color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.green[700]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    lokasi,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            // Tombol edit & delete
            Visibility(
              visible: isAdmin,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
