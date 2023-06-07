import 'package:flutter/material.dart';
import 'package:pokedex/utils/map_card_color.dart';
import 'package:pokedex/utils/map_type_icon.dart';

class TypeIcon extends StatelessWidget {
  final String type;
  const TypeIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Text(
        setTypeIcon(type),
        style: TextStyle(
          fontFamily: "PokeGoTypes",
          fontSize: 22,
          color: setCardColor(type),
        ),
      ),
    );
  }
}
