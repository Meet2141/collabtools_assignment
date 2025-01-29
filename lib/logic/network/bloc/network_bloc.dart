import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkStatusBloc extends Bloc<NetworkStatusEvent, NetworkStatusState> {
  final Connectivity _connectivity = Connectivity();

  NetworkStatusBloc() : super(NetworkStatusInitial()) {
    on<NetworkStatusChangedEvent>(_onNetworkStatusChanged);
    _listenToConnectivityChanges();
  }

  void _listenToConnectivityChanges() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool isOnline = results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi);
      add(NetworkStatusChangedEvent(isOnline: isOnline));
    });
  }

  void _onNetworkStatusChanged(NetworkStatusChangedEvent event, Emitter<NetworkStatusState> emit) {
    if (event.isOnline) {
      emit(NetworkOnline());
    } else {
      emit(NetworkOffline());
    }
  }
}
