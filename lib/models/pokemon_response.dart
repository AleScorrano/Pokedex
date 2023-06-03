class PokemonResponse {
  final int count;
  final String nextCursor;
  final List<dynamic> results;

  PokemonResponse({
    required this.count,
    required this.nextCursor,
    required this.results,
  });

  factory PokemonResponse.fromJson(Map<String, dynamic> data) =>
      PokemonResponse(
        count: data["count"],
        nextCursor: data["next"],
        results: data["results"],
      );
}
