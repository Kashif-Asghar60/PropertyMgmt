import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/dimensions_provider.dart';

class BolDCustomText extends StatelessWidget {

  const BolDCustomText({super.key, required this.text, required this.color});
   final String text;
      final Color color;

  @override
  Widget build(BuildContext context) {
        final dimensionsProvider = Provider.of<DimensionsProvider>(context);

    return AutoSizeText(
     text, 
          softWrap: true,
     style: TextStyle(
      fontSize: dimensionsProvider.textSize ,
      fontWeight: FontWeight.w700,
      color: color
     ),
        minFontSize: 10, // Set a minimum font size
      maxLines: 1, // Limit the text to one line
      overflow: TextOverflow.ellipsis,
    );
  }
}
class NormalCustomText extends StatelessWidget {
  const NormalCustomText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.size = 1.5,
  });

  final String text;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dimensionsProvider = Provider.of<DimensionsProvider>(context, listen: false);

    return AutoSizeText(
      text,
      style: TextStyle(
      //  fontSize: dimensionsProvider.textSize / 1.3,
      fontWeight: FontWeight.w600,
        color: color,

      ),
      softWrap: true,
    stepGranularity: 1,
      textScaleFactor: .78,
      minFontSize: 2, // Set a minimum font size
    // maxFontSize: 16,
      maxLines: 1, // Limit the text to one line
      overflow: TextOverflow.ellipsis,
      
    );
  }
}
