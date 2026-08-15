import 'package:flutter_test/flutter_test.dart';
import 'package:aniyoka/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MediaInfoViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
