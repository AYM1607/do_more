import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../widgets/async_image.dart';
import '../widgets/async_thumbnail.dart';
import '../widgets/carousel.dart';
import '../widgets/fractionally_screen_sized_box.dart';
import '../widgets/loading_indicator.dart';

/// A screen that shows a series of puctures in full resolution with zoom
/// capability and navigation controls.
class GalleryScreen extends StatelessWidget {
  /// An observable that emits a list of all the paths of the images the gallery
  /// will show.
  final ValueObservable<List<String>> pathsStream;

  /// An observable that emits a map that caches the files corresponding to the
  /// images to be shown.
  final ValueObservable<Map<String, Future<File>>> cacheStream;

  /// An observable that emits a map that caches the files corresponding to the
  /// thumbnails of the images to be shown.
  final ValueObservable<Map<String, Future<File>>> thumbnailCaceStream;

  /// A function to be called when an image needs to be fetched.
  final Function(String) fetchImage;

  /// The initial screen (picture) to be shown.
  ///
  /// If provided, the gallery will automatically show this image upon opening.
  final int initialScreen;

  /// A controller for the underlaying [PageView].
  final PageController _controller;

  /// Creates a screen that shows a series of puctures in full resolution with zoom
  /// capability and navigation controls
  ///
  /// [patshStream], [cacheStream] and [fetchImage] must not be null.
  GalleryScreen({
    @required this.pathsStream,
    @required this.cacheStream,
    this.initialScreen = 0,
    @required this.fetchImage,
    @required this.thumbnailCaceStream,
  })  : assert(pathsStream != null),
        assert(cacheStream != null),
        assert(fetchImage != null),
        assert(thumbnailCaceStream != null),
        _controller = PageController(
          initialPage: initialScreen,
          keepPage: false,
        );

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: pathsStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> listSnap) {
              // Wait until the images paths have been fetched.
              if (!listSnap.hasData) {
                return buildImagePlaceholder();
              }

              return PageView.builder(
                // Do not allow page changes on swipe. User manual controls,
                // the [PageView] gestures interfere with zooming otherwhise.
                physics: new NeverScrollableScrollPhysics(),
                controller: _controller,
                itemCount: listSnap.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final imagePath = listSnap.data[index];
                  fetchImage(imagePath);

                  return AsyncImage(
                    cacheId: imagePath,
                    cacheMap: cacheStream,
                  );
                },
              );
            },
          ),
          buildCloseButton(context),
          buildCarousel(),
        ],
      ),
    );
  }

  /// Jumps to the specified page.
  void animateToPage(int index) {
    final curve = Curves.easeInOut;
    final duration = Duration(milliseconds: 300);
    _controller.animateToPage(
      index,
      curve: curve,
      duration: duration,
    );
  }

  /// Builds the button that closes this screen.
  Widget buildCloseButton(BuildContext context) {
    return Positioned(
      left: 20,
      top: 60,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.close,
          size: 40,
        ),
      ),
    );
  }

  Widget buildCarousel() {
    return StreamBuilder(
      stream: thumbnailCaceStream,
      builder: (context, AsyncSnapshot<Map<String, Future<File>>> snap) {
        Widget carousel = Container();

        if (snap.hasData) {
          final cache = snap.data;
          List<Widget> carouselChildren = [];

          cache.keys.forEach(
            (key) {
              carouselChildren.add(
                AsyncThumbnail(
                  cacheId: key,
                  cacheStream: thumbnailCaceStream,
                ),
              );
            },
          );

          carousel = Carousel(
            onChanged: (index) => animateToPage(index),
            itemCount: cache.length,
            initialItem: initialScreen,
            children: carouselChildren,
          );
        }

        return Positioned(
          bottom: 20,
          child: FractionallyScreenSizedBox(
            widthFactor: 1,
            child: Column(
              children: <Widget>[
                carousel,
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a placeholder for an image.
  Widget buildImagePlaceholder() {
    return Container(
      color: Colors.black,
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }
}

enum Page { previous, next }
