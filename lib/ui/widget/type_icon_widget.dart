import 'package:flutter/material.dart';
import 'package:pokedex/utils/map_card_color.dart';
import 'package:pokedex/utils/map_type_icon.dart';

class TypeIcon extends StatelessWidget {
  final String type;
  final double? size;
  final double? opacity;
  final bool? extended;
  const TypeIcon({
    super.key,
    required this.type,
    this.size,
    this.opacity,
    this.extended,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Text(
        setTypeIcon(type),
        style: TextStyle(
          fontFamily: "PokeGoTypes",
          fontSize: size ?? 22,
          color: setTypeColor(type).withOpacity(opacity ?? 1),
        ),
      ),
    );
  }
}
