import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final Connectivity connectivity;
  final InternetConnectionChecker dataChecker;

  NetworkInfoImpl({required this.connectivity, required this.dataChecker});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    //with connectivity we can check our data use mobile data or wifi or ethernet or none
    if (result != ConnectivityResult.bluetooth &&
        result != ConnectivityResult.none) {
      // with DataConnectionChecker we can check clear connection with internet
      if (await dataChecker.hasConnection) {
        // device is connected to the internet
        return true;
      } else {
        // device connected wifi or mobile data or ethernet, but doesn't have connection with internet
        return false;
      }
    } else {
      // device not connected any of mobile data or wifi or ethernet.
      return false;
    }
  }
}
