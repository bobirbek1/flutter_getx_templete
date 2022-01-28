import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_template/core/platform/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity, InternetConnectionChecker])
void main() {
  late Connectivity connectivity;
  late InternetConnectionChecker internetChecker;
  late NetworkInfoImpl network;

  setUp(() {
    connectivity = MockConnectivity();
    internetChecker = MockInternetConnectionChecker();
    network = NetworkInfoImpl(
        connectivity: connectivity, dataChecker: internetChecker);
  });

  group("isConnected", () {
    setUp(() {
      when(connectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
    });

    test("Should forward the call to DataConnectionChecker.hasConnection",
        () async {
      final tHasConnection = Future.value(true);

      when(internetChecker.hasConnection).thenAnswer((_) => tHasConnection);

      final result = await network.isConnected;

      verify(internetChecker.hasConnection);
      verify(connectivity.checkConnectivity());
      expect(result, await tHasConnection);
    });

  });
group("is not connected",() {
    setUp(() {
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);
    });

    test("Should forward the call to DataConnectionChecker.hasConnection",
        () async {
      final tHasConnection = false;

      final result = await network.isConnected;

      verifyZeroInteractions(internetChecker);
      verify(connectivity.checkConnectivity());
      expect(result, await tHasConnection);
    });
  });
}
