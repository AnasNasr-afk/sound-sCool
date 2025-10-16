import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionHelper {
  static final ConnectionHelper _instance = ConnectionHelper._internal();
  factory ConnectionHelper() => _instance;
  ConnectionHelper._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _controller.stream;

  void initialize() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isConnected = result != ConnectivityResult.none;
      _controller.add(isConnected);
    });
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
