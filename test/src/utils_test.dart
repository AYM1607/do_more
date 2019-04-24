import 'dart:async';

import 'package:do_more/src/utils.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('DistinctStreamTransformer', () {
    test('should only emit non repeated elements', () {
      final stream = Stream.fromIterable([1, 1, 1, 2, 2, 2, 1, 1, 1, 1]);
      final transformedStream = stream.transform(DistinctStreamTransformer());

      expect(transformedStream.toList(), completion(equals([1, 2, 1])));
    });
  });
}
