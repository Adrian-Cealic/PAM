import 'package:equatable/equatable.dart';

import '../../../domain/entities/home.dart';

enum HomeStatus { loading, success, error }

class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.loading, this.data, this.errorMessage});

  final HomeStatus status;
  final HomeData? data;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, data, errorMessage];
}
