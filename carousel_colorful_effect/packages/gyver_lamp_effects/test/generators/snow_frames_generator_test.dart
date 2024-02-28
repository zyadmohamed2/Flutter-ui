import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

import '../helpers/frames_generator_test_sheet.dart';
import '../helpers/generator_settings_variant.dart';

void main() {
  group('SnowFramesGenerator', () {
    final settingsVariant = GeneratorSettingsVariant.all();

    test('has correct blur value', () {
      expect(SnowFramesGenerator(dimension: 16).blur, equals(3));
    });

    test('reset works correctly', () {
      const speed = 8;
      const scale = 33;
      final generator = SnowFramesGenerator(
        dimension: 16,
        random: math.Random(3333),
      );

      final initialFrame = generator.generate(speed: speed, scale: scale);

      generator
        ..generate(speed: speed, scale: scale)
        ..generate(speed: speed, scale: scale)
        ..generate(speed: speed, scale: scale);

      expect(
        generator.generate(speed: speed, scale: scale),
        isNot(equals(initialFrame)),
      );

      generator.reset();

      expect(
        generator.generate(speed: speed, scale: scale),
        equals(initialFrame),
      );
    });

    testWidgets(
      'renders correctly',
      (tester) async {
        addTearDown(tester.view.reset);
        tester.view.physicalSize = const Size(128, 128);
        tester.view.devicePixelRatio = 1.0;

        final settings = settingsVariant.currentValue!;
        final generator = SnowFramesGenerator(
          dimension: settings.dimension,
          random: math.Random(3333),
        );

        await tester.pumpWidget(
          RepaintBoundary(
            child: FramesGeneratorTestSheet(
              generator: generator,
              speed: settings.speed,
              scale: settings.scale,
            ),
          ),
        );

        await expectLater(
          find.byType(FramesGeneratorTestSheet),
          matchesGoldenFile('goldens/snow_frames_generator.${settings.id}.png'),
        );
      },
      variant: settingsVariant,
    );
  });
}
