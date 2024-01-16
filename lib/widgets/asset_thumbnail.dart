import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

import '/widgets/image_view.dart';
import '/widgets/video_view.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  Future<void> _showSnackbar(BuildContext context) async {
    final videoDuration = asset.videoDuration;
    if (videoDuration > const Duration(minutes: 1)) {
      Get.snackbar("Video", "Video duration exceeds 60 seconds");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            if (asset.type == AssetType.image) {
              return ImageView(
                imageFile: asset.file,
              );
            } else {
              return VideoView(
                videoFile: asset.file,
              );
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbnailData.then((value) => value!),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final bytes = snapshot.data;
        if (bytes == null) {
          // Handle error or show a placeholder image
          return const Placeholder();
        }

        return InkWell(
          onTap: () => _showSnackbar(context),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              if (asset.type == AssetType.video)
                Center(
                  child: Container(
                    color: Colors.blue,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
