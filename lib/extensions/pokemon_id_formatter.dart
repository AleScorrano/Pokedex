extension StringExtension on String {
  String pokemonIdFormatter() {
    return "#${this.padLeft(3, '0')}";
  }
}
