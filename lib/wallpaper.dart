import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class wallpaper extends StatefulWidget {
  const wallpaper({Key? key}) : super(key: key);

  @override
  State<wallpaper> createState() => _wallpaperState();
}

class _wallpaperState extends State<wallpaper> {
  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .toList();
    return imagePaths;
  }

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
              List? list=snapshot.data as List;
              return ListView.builder(itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      child: Image.asset(fit: BoxFit.fill,"${list[index]}"),
                    ),
                    IconButton(onPressed: () async {

                      print(list[index]);
                      File f = await getImageFileFromAssets('${list[index]}');
                      int location = WallpaperManager.BOTH_SCREEN; //can be Home/Lock Screen
                      bool result = await WallpaperManager.setWallpaperFromFile(f.path, location);
                      print(result);

                    }, icon: Icon(Icons.download),color: Colors.white,iconSize: 50,)
                  ],
                );
              },
              itemCount: list.length,);
            }
        },
        future: _initImages(),
      ),
    );
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');
    var filepath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);

    Directory f=Directory("$filepath/cdmi1");
    if(!await f.exists())
      {
        await f.create();
      }
    final file = File('${f.path}/1.jpg');
    await file.create();
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
}
