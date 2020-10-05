import 'package:flutter/painting.dart' show Color;
import 'package:palette/palette.dart' as cp;
import 'package:palette/palette.dart' show ColorSpace;
import 'package:flutter_color_models/flutter_color_models.dart';

/// Contains a [List] of [ColorModel]s.
///
/// Has constructors for generating new color palettes, as well as methods
/// and operators for modifying and extracting colors from the palette.
class ColorPalette extends cp.ColorPalette {
  /// Contains a [List] of [ColorModel]s.
  ///
  /// Has constructors for generating new color palettes, as well as methods
  /// and operators for modifying and extracting colors from the palette.
  ///
  /// [colors] must not be `null`.
  const ColorPalette(this.colors)
      : assert(colors != null),
        super(colors);

  @override
  final List<ColorModel> colors;

  /// Returns the color palette as a list of [Color]s.
  List<Color> toColors({bool growable = true}) => colors.map<Color>(
      (color) => color.toColor()).toList(growable: growable);

  @override
  ColorPalette getRange(int start, int end) =>
      ColorPalette(colors.getRange(start, end).toList());

  /// Constructs a [ColorPalette] from [colors].
  factory ColorPalette.from(List<Color> colors) {
    assert(colors != null);

    return ColorPalette(List<ColorModel>.from(
        colors.map((color) => RgbColor.fromColor(color))));
  }

  /// Returns a [ColorPalette] with an empty list of [colors].
  factory ColorPalette.empty() => ColorPalette(<ColorModel>[]);

  /// Generates a [ColorPalette] by selecting colors with hues
  /// to both sides of [color]'s hue value.
  ///
  /// If [numberOfColors] is odd, [color] will be included in the palette.
  /// If even, [color] will be excluded from the palette. [numberOfColors]
  /// defaults to `5`, must be `> 0`, and must not be `null`.
  ///
  /// [distance] is the base spacing between the selected colors' hue values.
  /// [distance] defaults to `30` degrees and must not be `null`.
  ///
  /// [hueVariability], [saturationVariability], and [brightnessVariability],
  /// if `> 0`, add a degree of randomness to the selected color's hue,
  /// saturation, and brightness (HSB's value) values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  factory ColorPalette.adjacent(
    Color seed, {
    int numberOfColors = 5,
    num distance = 30,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
  }) {
    assert(seed != null);
    assert(distance != null);
    assert(numberOfColors != null && numberOfColors > 0);
    assert(
        hueVariability != null && hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability != null &&
        saturationVariability >= 0 &&
        saturationVariability <= 100);
    assert(brightnessVariability != null &&
        brightnessVariability >= 0 &&
        brightnessVariability <= 100);

    return _cast(cp.ColorPalette.adjacent(
      RgbColor.fromColor(color),
      numberOfColors: numberOfColors,
      distance: distance,
      hueVariability: hueVariability,
      saturationVariability: saturationVariability,
      brightnessVariability: brightnessVariability,
    ));
  }

  /// Generates a [ColorPalette] by selecting colors with hues
  /// evenly spaced around the color wheel from [color].
  ///
  /// [numberOfColors] defaults to `5`, must be `> 0` and must
  /// not be `null`.
  ///
  /// [hueVariability], [saturationVariability], and [brightnessVariability],
  /// if `> 0`, add a degree of randomness to the selected color's hue,
  /// saturation, and brightness (HSB's value) values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  factory ColorPalette.polyad(
    Color seed, {
    int numberOfColors = 5,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
  }) {
    assert(seed != null);
    assert(numberOfColors != null && numberOfColors > 0);
    assert(
        hueVariability != null && hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability != null &&
        saturationVariability >= 0 &&
        saturationVariability <= 100);
    assert(brightnessVariability != null &&
        brightnessVariability >= 0 &&
        brightnessVariability <= 100);

    return _cast(cp.ColorPalette.polyad(
      RgbColor.fromColor(color),
      numberOfColors: numberOfColors,
      hueVariability: hueVariability,
      saturationVariability: saturationVariability,
      brightnessVariability: brightnessVariability,
    ));
  }

  /// Generates a [ColorPalette] with [numberOfColors] at random, constrained
  /// within the specified hue, saturation, and brightness ranges.
  ///
  /// [minHue] and [maxHue] are used to set the range of hues that will be
  /// selected from. If `minHue < maxHue`, the range will run in a clockwise
  /// direction between the two, however if `minHue > maxHue`, the range will
  /// run in a counter-clockwise direction. Both [minHue] and [maxHue] must
  /// be `>= 0 && <= 360` and must not be `null`.
  ///
  /// [minSaturation] and [maxSaturation] are used to set the range of the
  /// generated colors' saturation values. [minSaturation] must be
  /// `<= maxSaturation` and [maxSaturation] must be `>= minSaturation`.
  /// Both [minSaturation] and [maxSaturation] must be `>= 0 && <= 100`.
  ///
  /// [minBrightness] and [maxBrightness] are used to set the range of the
  /// generated colors' percieved brightness values. [minBrightness] must be
  /// `<= maxBrightness` and [maxBrightness] must be `>= minBrightness`.
  /// Both [minBrightness] and [maxBrightness] must be `>= 0 && <= 100`.
  ///
  /// If [distributeHues] is `true`, the generated colors will be spread
  /// evenly across the range of hues allowed for. [distributeHues] must
  /// not be `null`.
  ///
  /// [distributionVariability] will add a degree of randomness to the selected
  /// hues, if [distributeHues] is `true`. If `null`, [distributionVariability]
  /// defaults to `(minHue - maxHue).abs() / numberOfColors / 4`. To allow for
  /// no variability at all, [distributionVariability] must be set to `0`.
  ///
  /// [colorSpace] defines the color space colors will be generated and
  /// returned in. [colorSpace] defaults to [ColorSpace.rgb] and must not
  /// be `null`.
  factory ColorPalette.random(
    int numberOfColors, {
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minBrightness = 0,
    num maxBrightness = 100,
    bool distributeHues = true,
    num distributionVariability,
    ColorSpace colorSpace = ColorSpace.rgb,
  }) {
    assert(numberOfColors != null && numberOfColors > 0);
    assert(minHue != null && minHue >= 0 && minHue <= 360);
    assert(maxHue != null && maxHue >= 0 && maxHue <= 360);
    assert(minSaturation != null &&
        minSaturation >= 0 &&
        minSaturation <= maxSaturation);
    assert(maxSaturation != null &&
        maxSaturation >= minSaturation &&
        maxSaturation <= 100);
    assert(minBrightness != null &&
        minBrightness >= 0 &&
        minBrightness <= maxBrightness);
    assert(maxBrightness != null &&
        maxBrightness >= minBrightness &&
        maxBrightness <= 100);
    assert(distributeHues != null);
    assert(colorSpace != null);

    return _cast(cp.ColorPalette.random(
      numberOfColors,
      minHue: minHue,
      maxHue: maxHue,
      minSaturation: minSaturation,
      maxSaturation: maxSaturation,
      minBrightness: minBrightness,
      maxBrightness: maxBrightness,
      distributeHues: distributeHues,
      distributionVariability: distributionVariability,
      colorSpace: colorSpace,
    ));
  }

  /// Generates a [ColorPalette] by selecting colors to both sides
  /// of the color with the opposite [hue] of [color].
  ///
  /// If [numberOfColors] is even, the coolor opposite of [color] will
  /// be included in the palette. If odd, the opposite color will be
  /// excluded from the palette. [numberOfColors] defaults to `3`, must
  /// be `> 0`, and must not be `null`.
  ///
  /// [distance] is the base spacing between the selected colors' hue values.
  /// [distance] defaults to `30` degrees and must not be `null`.
  ///
  /// [hueVariability], [saturationVariability], and [brightnessVariability],
  /// if `> 0`, add a degree of randomness to the selected color's hue,
  /// saturation, and brightness (HSB's value) values, respectively.
  ///
  /// [hueVariability] defaults to `0`, must be `>= 0 && <= 360`,
  /// and must not be `null`.
  ///
  /// [saturationVariability] and [brightnessVariability] both default to `0`,
  /// must be `>= 0 && <= 100`, and must not be `null`.
  factory ColorPalette.splitComplimentary(
    Color seed, {
    int numberOfColors = 3,
    num distance = 30,
    num hueVariability = 0,
    num saturationVariability = 0,
    num brightnessVariability = 0,
  }) {
    assert(seed != null);
    assert(numberOfColors != null && numberOfColors > 0);
    assert(
        hueVariability != null && hueVariability >= 0 && hueVariability <= 360);
    assert(saturationVariability != null &&
        saturationVariability >= 0 &&
        saturationVariability <= 100);
    assert(brightnessVariability != null &&
        brightnessVariability >= 0 &&
        brightnessVariability <= 100);

    return _cast(cp.ColorPalette.splitComplimentary(
      RgbColor.fromColor(color),
      numberOfColors: numberOfColors,
      distance: distance,
      hueVariability: hueVariability,
      saturationVariability: saturationVariability,
      brightnessVariability: brightnessVariability,
    ));
  }

  /// Generates a [ColorPalette] from [colorPalette] by appending or
  /// inserting the opposite colors of every color in [colorPalette].
  ///
  /// __Note:__ Use the [opposite] methods to flip every color in a
  /// palette to their respective opposites without preserving the
  /// original colors.
  ///
  /// [colorPalette] must not be `null`.
  ///
  /// If [insertOpposites] is `true`, the generated colors will be inserted
  /// into the list of colors after their respective base colors. If `false`,
  /// the generated colors will be appended to the end of the list.
  /// [insertOpposites] defaults to `true` and must not be `null`.
  factory ColorPalette.opposites(
    ColorPalette colorPalette, {
    bool insertOpposites = true,
  }) {
    assert(colorPalette != null);
    assert(insertOpposites != null);

    return _cast(cp.ColorPalette.opposites(
      colorPalette,
      insertOpposites: insertOpposites,
    ));
  }

  /// Casts [colorPalette] from the `palette` package's [ColorPalette] class
  /// to the `flutter_palette` package's [ColorPalette] class.
  static ColorPalette _cast(cp.ColorPalette colorPalette) {
    assert(colorPalette != null);

    return ColorPalette(colorPalette.colors);
  }

  /// Returns the concatenation of this palette's colors and [other]s'.
  ///
  /// [other] may be a [ColorPalette], [List<Color>], or a [List<ColorModel>].
  @override
  ColorPalette operator +(dynamic other) {
    assert(other is ColorPalette ||
        other is List<ColorModel> ||
        other is List<Color>);

    List<ColorModel> colors;

    if (other is ColorPalette) {
      colors = other.colors;
    } else if (other is List<ColorModel>) {
      colors = other;
    } else if (other is List<Color>) {
      colors = List<ColorModel>.from(
          other.map((color) => RgbColor.fromColor(color)));
    }

    return ColorPalette(this.colors + colors);
  }
}
