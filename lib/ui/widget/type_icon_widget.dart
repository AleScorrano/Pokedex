import 'package:flutter/material.dart';
import 'package:pokedex/utils/map_card_color.dart';
import 'package:pokedex/utils/map_type_icon.dart';

class TypeIcon extends StatelessWidget {
  final String type;
  final double? size;
  final double? opacity;
  const TypeIcon({
    super.key,
    required this.type,
    this.size,
    this.opacity,
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
          color: setCardColor(type).withOpacity(opacity ?? 1),
        ),
      ),
    );
  }
}
