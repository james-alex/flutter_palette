import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:meta/meta.dart';
import 'package:palette/palette.dart' as cp;
import 'package:unique_list/unique_list.dart';

/// Casts the colors in [palette] from the [color_model] package's
/// [ColorModel] class, to the [flutter_color_model] package's [ColorModel]
/// class.
List<ColorModel> cast(
  cp.ColorPalette palette, {
  @required bool growable,
  @required bool unique,
}) {
  assert(palette != null);
  assert(growable != null);
  assert(unique != null);

  final colors = palette.colors.map<ColorModel>((color) {
    ColorModel castColor;

    final colorValues = color.toListWithAlpha();

    if (color is cp.CmykColor) {
      castColor = CmykColor.fromList(colorValues);
    } else if (color is cp.HsbColor) {
      castColor = HsbColor.fromList(colorValues);
    } else if (color is cp.HsiColor) {
      castColor = HsiColor.fromList(colorValues);
    } else if (color is cp.HslColor) {
      castColor = HslColor.fromList(colorValues);
    } else if (color is cp.HspColor) {
      castColor = HspColor.fromList(colorValues);
    } else if (color is cp.LabColor) {
      castColor = LabColor.fromList(colorValues);
    } else if (color is cp.RgbColor) {
      castColor = RgbColor.fromList(color.toPreciseListWithAlpha());
    } else if (color is cp.XyzColor) {
      castColor = XyzColor.fromList(colorValues);
    }

    return castColor;
  });

  return unique
      ? UniqueList<ColorModel>.of(colors, growable: growable)
      : List<ColorModel>.of(colors, growable: growable);
}
