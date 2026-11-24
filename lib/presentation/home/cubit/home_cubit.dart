import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/data_exception.dart';
import '../../../domain/repositories/learning_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  final LearningRepository _repository;

  @override
  void onChange(Change<HomeState> change) {
    super.onChange(change);
    debugPrint('HomeCubit: ${change.currentState.status} -> ${change.nextState.status}');
  }

  Future<void> load() async {
    emit(const HomeState(status: HomeStatus.loading));
    
    try {
      final data = await _repository.getHomeData();
      if (isClosed) return;
      emit(HomeState(status: HomeStatus.success, data: data));
      
    } on DataException catch (error) {
      if (isClosed) return;
      emit(HomeState(status: HomeStatus.error, errorMessage: error.message));
    }
    
  }
  
}
