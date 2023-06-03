import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/services/network_service.dart';

void main() {
  late NetworkService networkService;

  setUp(() {
    networkService = NetworkService();
  });

  test(
    "REST call to initialData endpoint",
    () async {
      final response = await networkService.getPokemonsURLList(limit: 10);

      expect(response, isNotNull);
      expect(response.count, isPositive);
      expect(response.results, isNotNull);
      expect(response.results, isNotEmpty);
    },
  );
}
