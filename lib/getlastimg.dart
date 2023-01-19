import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class getlastimg extends StatefulWidget {
  const getlastimg({Key? key}) : super(key: key);

  @override
  State<getlastimg> createState() => _getlastimgState();
}

class _getlastimgState extends State<getlastimg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        builder: (context, snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator(),);
          }
          else
          {
            List<AssetEntity>? list=snapshot.data as List<AssetEntity>;
            return ListView.builder(itemBuilder: (context, index) {
              return AssetEntityImage(
                list[0],
                isOriginal: false, // Defaults to `true`.
                thumbnailSize: const ThumbnailSize.square(200), // Preferred value.
                thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
              );
              // return Stack(
              //   alignment: Alignment.bottomRight,
              //   children: [
              //     Container(
              //       height: 400,
              //       width: double.infinity,
              //       child: Image.asset(fit: BoxFit.fill,"${list[index]}"),
              //     ),
              //     IconButton(onPressed: () async {
              //
              //       print(list[index]);
              //       File f = await getImageFileFromAssets('${list[index]}');
              //       int location = WallpaperManager.BOTH_SCREEN; //can be Home/Lock Screen
              //       bool result = await WallpaperManager.setWallpaperFromFile(f.path, location);
              //       print(result);
              //
              //     }, icon: Icon(Icons.download),color: Colors.white,iconSize: 50,)
              //   ],
              // );
            },
              itemCount: 1,);
          }
        },
        // future: _initImages(),
        future: _fetchAssets(),
      ),
    );
  }
  List<AssetEntity> assets = [];
  Future<List<AssetEntity>> _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList();
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1, // end at a very big index (to get all the assets)
    );
    print(recentAssets);

    // setState(() => assets = recentAssets);
    return recentAssets;
  }

}
