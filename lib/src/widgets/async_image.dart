import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rxdart/rxdart.dart';

import './loading_indicator.dart';

/// A widget that shows an image given a cache map and its cache id.
///
/// A placeholder is shown while it loads.
class AsyncImage extends StatelessWidget {
  /// The id of the image inside the [cacheMap].
  final String cacheId;

  /// A cache that maps an image path to its file.
  final Observable<Map<String, Future<File>>> cacheMap;

  /// Creates a widget that shows an image given a cache map and its cache id.
  ///
  /// A placeholder is shown while the image loads.
  AsyncImage({
    @required this.cacheId,
    @required this.cacheMap,
  })  : assert(cacheId != null),
        assert(cacheMap != null);

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: cacheMap,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Future<File>>> imagesCacheSnap) {
        // Wait until the images cache has data.
        if (!imagesCacheSnap.hasData) {
          return buildImagePlaceholder();
        }

        return FutureBuilder(
          future: imagesCacheSnap.data[cacheId],
          builder: (BuildContext context, AsyncSnapshot<File> imageFileSnap) {
            // Wait until the future of the file for this image resolves.
            if (!imageFileSnap.hasData) {
              return buildImagePlaceholder();
            }

            return PhotoView(
              imageProvider: FileImage(imageFileSnap.data),
              minScale: .2,
              maxScale: 2.0,
            );
          },
        );
      },
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      color: Colors.black,
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }
}
