import 'package:ahes_maps/constants/colors.dart';
import 'package:flutter/material.dart';

class JadwalCard extends StatelessWidget {
  final String rombongan;
  final String tanggal;
  final String waktu;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String status;
  final bool isAdmin;

  const JadwalCard(
      {super.key,
      required this.rombongan,
      required this.tanggal,
      required this.waktu,
      required this.onEdit,
      required this.onDelete,
      required this.status,
      required this.isAdmin});

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
                const Text(
                  "Jadwal Keberangkatan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == "Terkonfirmasi"
                        ? Colors.green[100]
                        : status == "Reschedule"
                            ? Colors.yellow[100]
                            : Colors.red[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == "Terkonfirmasi"
                          ? Colors.green[800]
                          : status == "Reschedule"
                              ? Colors.yellow[800]
                              : Colors.red[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Nomor Rombongan:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              rombongan,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.flight_takeoff, size: 18, color: hijauUtama),
                const SizedBox(width: 6),
                Text(tanggal,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: hijauUtama),
                const SizedBox(width: 6),
                Text(waktu,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
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
