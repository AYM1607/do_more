import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../widgets/loading_indicator.dart';

/// An Widget that displays an image given a stream of a cache and the id for
/// this image.
class AsyncThumbnail extends StatelessWidget {
  /// A stream of a cache that maps an image path to the future of its file.
  final Observable<Map<String, Future<File>>> cacheStream;

  /// The id of the image to be displayed.
  ///
  /// The image will load undefinitely if the the provided id is not contained
  /// in the provided cache.
  final String cacheId;

  /// Creates a widget that displays an image given a stream of a cache and
  /// the id for this image.
  ///
  /// Neither [cacheStream] nor [cacheId] can be null.
  AsyncThumbnail({
    @required this.cacheStream,
    @required this.cacheId,
  })  : assert(cacheId != null),
        assert(cacheStream != null);

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: cacheStream,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Future<File>>> thumbailsCacheSnap) {
        // Wait until the images cache has data.
        if (!thumbailsCacheSnap.hasData) {
          return _buildThumbnailPlaceholder();
        }

        return FutureBuilder(
          future: thumbailsCacheSnap.data[cacheId],
          builder:
              (BuildContext context, AsyncSnapshot<File> thumbnailFileSnap) {
            // Wait until the future of the file for this image resolves.
            if (!thumbnailFileSnap.hasData) {
              return _buildThumbnailPlaceholder();
            }

            return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(thumbnailFileSnap.data),
            );
          },
        );
      },
    );
  }

  // TODO: Find a better animation for the placeholder.
  Widget _buildThumbnailPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey,
      ),
      child: Center(
        child: LoadingIndicator(
          size: 30,
        ),
      ),
    );
  }
}
