import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static Future<bool> isConnected() async {
    var connectivityResultList = await Connectivity().checkConnectivity();
    for (var result in connectivityResultList) {
      if (result != ConnectivityResult.none) {
        return true;
      }
    }
    return false;
  }
}
