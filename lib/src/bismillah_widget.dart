import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

/// A widget that renders the Bismillah text with consistent styling.
///
/// This widget displays the Bismillah text "ﱁ  ﱂﱃﱄ\n" using the QCF_BSML font.
class BismillahWidget extends StatelessWidget {
  /// Responsive font size multiplier (sp factor)
  final double sp;
  
  /// Optional custom color for the Bismillah text
  final Color? color;

  const BismillahWidget({
    super.key,
    this.sp = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "ﱁ  ﱂﱃﱄ\n",
      style: TextStyle(
        fontFamily: "QCF_BSML",
        package: 'qcf_quran',
        fontSize: getScreenType(context) == ScreenType.large
            ? 13.2 / sp
            : 18 / sp,
        color: color ?? Colors.black,
      ),
    );
  }
}