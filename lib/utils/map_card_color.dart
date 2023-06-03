import 'package:flutter/material.dart';

Color setCardColor(String type) {
  type = type.toLowerCase();

  switch (type) {
    case 'fire':
      return Color(0xfffa9950);

    case 'grass':
      return Color(0xff91eb5b);

    case 'water':
      return Color(0xFF69b9e3);

    case 'rock':
      return Color(0xffedd040);

    case 'bug':
      return Color(0xffbed41c);

    case 'normal':
      return Color(0xffC6C6A7);

    case 'poison':
      return Color(0xffd651d4);

    case 'electric':
      return Color(0xffF7D02C);

    case 'ground':
      return Color(0xfff5d37d);
    case 'ice':
      return Color(0xff79dbdb);

    case 'dark':
      return Color(0xffa37e65);

    case 'fairy':
      return Color(0xfffaa7d0);

    case 'psychic':
      return Color(0xffff80a6);

    case 'fighting':
      return Color(0xffe8413a);

    case 'ghost':
      return Color(0xff9063c9);

    case 'flying':
      return Color(0xffbda8f7);

    case 'dragon':
      return Color(0xff9065f7);

    case 'steel':
      return Color(0xffa0a0de);

    default:
      return Color(0xffdbd9d9);
  }
}

Color setTypeColor(String type) {
  type = type.toLowerCase();

  switch (type) {
    case 'fire':
      return Color(0xffF08030);

    case 'grass':
      return Color(0xff7AC74C);

    case 'water':
      return Color(0xFF6390F0);

    case 'rock':
      return Color(0xffB6A136);

    case 'bug':
      return Color(0xffA8B820);

    case 'normal':
      return Color(0xffA8A878);

    case 'poison':
      return Color(0xffA33EA1);

    case 'electric':
      return Color(0xfffce321);

    case 'ground':
      return Color(0xffE2BF65);

    case 'ice':
      return Color(0xff98D8D8);

    case 'dark':
      return Color(0xff705746);

    case 'fairy':
      return Color(0xffD685AD);

    case 'psychic':
      return Color(0xffF95587);

    case 'fighting':
      return Color(0xffC22E28);

    case 'ghost':
      return Color(0xff735797);

    case 'flying':
      return Color(0xffA98FF3);

    case 'dragon':
      return Color(0xff6F35FC);

    case 'steel':
      return Color(0xffB7B7CE);

    default:
      return Color(0xffdbd9d9);
  }
}
