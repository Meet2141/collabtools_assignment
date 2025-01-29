import 'package:equatable/equatable.dart';

abstract class NetworkStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkStatusInitial extends NetworkStatusState {}

class NetworkOnline extends NetworkStatusState {}

class NetworkOffline extends NetworkStatusState {}
