import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:marvel/main.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/models/credentials.dart';
import 'package:marvel/models/thumbnail.dart';
import 'package:marvel/modules/character/character_card.dart';
import 'package:marvel/modules/character/character_controller.dart';
import 'package:marvel/modules/character/character_list_page.dart';
import 'package:marvel/modules/menu/menu_handler.dart';
import 'package:marvel/modules/sign/sign_start_up_controller.dart';
import 'package:marvel/modules/sign/sign_start_up_page.dart';
import 'package:marvel/modules/ui/image_preview.ui.dart';
import 'package:marvel/modules/ui/scaffold_extend_body_ui.dart';
import 'package:marvel/services/network_connectivity.dart';
import 'package:nock/nock.dart';

const url = "http://gateway.marvel.com";
const String characterspath = '/v1/public/characters';
const String seriespath = '/v1/public/series';
const int characterId = 1011334;

Widget buildWithMediaQueryWidget(Widget widget) {
  return MediaQuery(
      data: const MediaQueryData(), child: MaterialApp(home: widget));
}

Widget buildWithMaterial(Widget widget) {
  return buildWithMediaQueryWidget(
    ScaffoldExtendBodyUI(
      body: buildWithMediaQueryWidget(
        widget,
      ),
    ),
  );
}

Future<void> main() async {
  setUpAll(() {
    nock.init();
  });

  testWidgets('MottuMarvel Widget test', (WidgetTester tester) async {
    Get.put(NetworkConnectivity(), permanent: true);
    await tester.pumpWidget(const MottuMarvel());
  });

  testWidgets('ScaffoldExtendBodyUI Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildWithMediaQueryWidget(
        ScaffoldExtendBodyUI(
          body: const Text('I am here!'),
        ),
      ),
    );

    expect(
      find.text('I am here!'),
      findsOneWidget,
      reason: 'ScaffoldExtendBodyUI Widget test fail',
    );
  });

  testWidgets('ImagePreview Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(buildWithMediaQueryWidget(
      const ImagePreviewUI(
        imageUrl:
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fletsenhance.io%2F&psig=AOvVaw26mQqy9dR4gJL_bfUTn7MM&ust=1725384001671000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCIC_2bXipIgDFQAAAAAdAAAAABAE',
      ),
    ));

    expect(
      find.image(const CachedNetworkImageProvider(
          'https://www.google.com/url?sa=i&url=https%3A%2F%2Fletsenhance.io%2F&psig=AOvVaw26mQqy9dR4gJL_bfUTn7MM&ust=1725384001671000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCIC_2bXipIgDFQAAAAAdAAAAABAE')),
      findsOneWidget,
      reason: 'ImagePreview Widget test fail',
    );
  });

  testWidgets('MenuHandler Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(buildWithMediaQueryWidget(
      const MenuHandler(),
    ));

    expect(
      find.byIcon(Icons.menu),
      findsWidgets,
      reason: 'MenuHandler Widget test fail',
    );
  });

  testWidgets('CharacterCard Widget test', (WidgetTester tester) async {
    Character character = const Character(
      id: 1011334,
      name: '3-D Man',
      description: "I am 3-D Man",
      thumbnail: Thumbnail(
        path: 'http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784',
        ext: 'jpg',
      ),
    );
    await tester.pumpWidget(
      buildWithMaterial(
        CharacterCard(
          character: character,
          animate: false,
        ),
      ),
    );

    expect(
      find.text(character.name),
      findsWidgets,
      reason: 'character.name Widget test fail',
    );

    expect(
      find.image(CachedNetworkImageProvider(character.imageUrl)),
      findsWidgets,
      reason: 'character.imageUrl Widget test fail',
    );
  });

  testWidgets('SignStartUpPage Widget test', (WidgetTester tester) async {
    Get.put(SignStartUpController());
    await tester.pumpWidget(
      buildWithMediaQueryWidget(
        const SignStartUpPage(
          height: 100,
        ),
      ),
    );

    expect(
      find.text('auto_join'.tr.toUpperCase()),
      findsOneWidget,
      reason: 'auto_join Widget test fail',
    );

    expect(
      find.text('join'.tr.toUpperCase()),
      findsOneWidget,
      reason: 'join Widget test fail',
    );
  });

  testWidgets('CharacterListPage Widget test', (WidgetTester tester) async {
    Get.put(CharacterController());
    await tester.pumpWidget(
      buildWithMediaQueryWidget(
        const CharacterListPage(),
      ),
    );
    await tester.pumpAndSettle();
  });

  testWidgets('NetworkConnectivity event channel test',
      (WidgetTester tester) async {
    Get.put(NetworkConnectivity(), permanent: true);
    bool networkConnectivityEventChannelOk =
        await NetworkConnectivity.instance.listen();

    expect(
      networkConnectivityEventChannelOk,
      true,
      reason: "NetworkConnectivity event channel test",
    );
  });

  test("Listing characters test", () async {
    Map<String, dynamic> credentials = Credentials.refresh().toJson();
    String query = Uri(queryParameters: credentials).query;
    String authenticatedPath = "$characterspath$query";
    final interceptor = nock(url).get(authenticatedPath)
      ..reply(
        HttpStatus.ok,
        "result",
      );

    final http.Response response =
        await http.Client().get(Uri.parse("$url$authenticatedPath"));

    expect(interceptor.isDone, true);
    expect(response.statusCode, HttpStatus.ok,
        reason: 'Listing characters test fail');
  });

  test("Getting characters test", () async {
    Map<String, dynamic> credentials = Credentials.refresh().toJson();
    String query = Uri(queryParameters: credentials).query;
    String authenticatedPath = "$characterspath/$characterId$query";
    final interceptor = nock(url).get(authenticatedPath)
      ..reply(
        HttpStatus.ok,
        "result",
      );

    final http.Response response =
        await http.Client().get(Uri.parse("$url$authenticatedPath"));

    expect(
      interceptor.isDone,
      true,
    );
    expect(response.statusCode, HttpStatus.ok,
        reason: 'Getting characters test fail');
  });

  test("Listing series test", () async {
    Map<String, dynamic> credentials = Credentials.refresh().toJson();
    String query = Uri(queryParameters: credentials).query;
    String authenticatedPath = "$characterspath/$characterId/series$query";

    final interceptor = nock(url).get(authenticatedPath)
      ..reply(
        HttpStatus.ok,
        "result",
      );

    final http.Response response =
        await http.Client().get(Uri.parse("$url$authenticatedPath"));

    expect(interceptor.isDone, true);
    expect(response.statusCode, HttpStatus.ok,
        reason: 'Listing series test fail');
  });
}
