import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  double _offset;
  static const kDefaultItemSize = 100.0;
  static const kDefaultSeparatorSize = 10.0;
  ScrollController _controller = ScrollController();
  int _currentWidgetIndex = 0;
  initState() {
    super.initState();
    _controller.addListener(displayCurrentWidget);
  }

  void scrollToItem(int itemIndex) {
    final position = (kDefaultSeparatorSize + kDefaultItemSize) * itemIndex;
    _controller.animateTo(
      position,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
    );
  }

  void displayCurrentWidget() {
    final currentPosition = _controller.offset;
    int newWidgetIndex;
    if (currentPosition < 0) {
      newWidgetIndex = 0;
    } else {
      final distanceFromLower =
          currentPosition % (kDefaultSeparatorSize + kDefaultItemSize);
      if (distanceFromLower <= (kDefaultSeparatorSize + kDefaultItemSize) / 2) {
        newWidgetIndex =
            currentPosition ~/ (kDefaultSeparatorSize + kDefaultItemSize);
      } else {
        newWidgetIndex =
            currentPosition ~/ (kDefaultSeparatorSize + kDefaultItemSize) + 1;
      }
    }
    if (newWidgetIndex != _currentWidgetIndex) {
      _currentWidgetIndex = newWidgetIndex;
      print(_currentWidgetIndex);
    }
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _offset = width / 2 - 50;
    return Container(
      height: 100.0,
      child: ListView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: _offset),
          GestureDetector(
            onTap: () => scrollToItem(0),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              width: kDefaultItemSize,
              child: Center(
                child: Text('0'),
              ),
            ),
          ),
          SizedBox(width: kDefaultSeparatorSize),
          GestureDetector(
            onTap: () => scrollToItem(1),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              width: kDefaultItemSize,
              child: Center(
                child: Text('1'),
              ),
            ),
          ),
          SizedBox(width: kDefaultSeparatorSize),
          GestureDetector(
            onTap: () => scrollToItem(2),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              width: kDefaultItemSize,
              child: Center(
                child: Text('2'),
              ),
            ),
          ),
          SizedBox(width: kDefaultSeparatorSize),
          GestureDetector(
            onTap: () => scrollToItem(3),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              width: kDefaultItemSize,
              child: Center(
                child: Text('3'),
              ),
            ),
          ),
          SizedBox(width: kDefaultSeparatorSize),
          GestureDetector(
            onTap: () => scrollToItem(4),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              width: kDefaultItemSize,
              child: Center(
                child: Text('4'),
              ),
            ),
          ),
          SizedBox(width: _offset),
        ],
      ),
    );
  }
}
