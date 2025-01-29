import 'package:equatable/equatable.dart';

abstract class NetworkStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkStatusChangedEvent extends NetworkStatusEvent {
  final bool isOnline;

  NetworkStatusChangedEvent({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}
