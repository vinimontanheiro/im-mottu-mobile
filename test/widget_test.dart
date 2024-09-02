// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:marvel/models/credentials.dart';
import 'package:nock/nock.dart';

const url = "http://gateway.marvel.com";
const String path = '/v1/public/characters';

Future<void> main() async {
  setUpAll(() {
    nock.init();
  });

  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MottuMarvel());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  test("example", () async {
    final interceptor = nock(url).get(path)
      ..reply(
        200,
        "result",
      );

    final http.Response response = await http.Client().get(
        Uri.parse("$url$path")
            .replace(queryParameters: Credentials.refresh().toJson()));

    expect(interceptor.isDone, true);
    expect(response.statusCode, 200);
    expect(response.body, "result");
  });
}
