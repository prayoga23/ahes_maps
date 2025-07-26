import 'package:ahes_maps/constants/colors.dart';
import 'package:flutter/material.dart';

Widget carouselCard(
    BuildContext context, String namaBangunan, String imageUrl, String jarak) {
  return Card(
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Image.network(imageUrl),
                ),
              );
            },
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  namaBangunan,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: hijauMuda,
                    ),
                    const SizedBox(width: 4),
                    double.parse(jarak) > 1000
                        ? Text(
                            "${(double.parse(jarak) / 1000).toStringAsFixed(2)} km",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          )
                        : Text(
                            "$jarak m",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
