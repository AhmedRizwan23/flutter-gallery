import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '/widgets/asset_thumbnail.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> assets = [];
  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum; // Make selectedAlbum nullable

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  Future<void> _fetchAssets() async {
    // Fetch all available albums in the phone storage
    albums = await PhotoManager.getAssetPathList(type: RequestType.video);

    if (albums.isNotEmpty) {
      selectedAlbum = albums.first;
      assets = await selectedAlbum!.getAssetListRange(
        start: 0,
        end: 100000,
        //   type: RequestType.image, // Adjusted to fetch image assets
      );
    }
    setState(() {});
  }

  void _onAlbumChanged(AssetPathEntity? album) async {
    if (album != null) {
      selectedAlbum = album;
      assets = await selectedAlbum!.getAssetListRange(
        start: 0,
        end: 100000,
        //  type: RequestType.image, // Adjusted to fetch image assets
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          if (albums.isNotEmpty)
            DropdownButton<AssetPathEntity>(
              value: selectedAlbum,
              items: albums
                  .map((album) => DropdownMenuItem(
                        value: album,
                        child: Text(album.name),
                      ))
                  .toList(),
              onChanged: _onAlbumChanged,
            ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(
            asset: assets[index],
          );
        },
      ),
    );
  }
}
