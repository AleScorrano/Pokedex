class DatabaseError extends Error {
  final String? reasonPhrase;

  DatabaseError(this.reasonPhrase);
}
