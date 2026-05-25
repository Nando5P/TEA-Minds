import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/child_entity.dart';
import '../../../domain/repositories/child_repository.dart';
import 'child_state.dart';

class ChildCubit extends Cubit<ChildState> {
  final ChildRepository _repository;

  ChildCubit(this._repository) : super(ChildState());

  void selectChild(Child child) {
    emit(state.copyWith(selectedChild: child));
  }

  void loadChildren(String tutorId) {
    emit(state.copyWith(isLoading: true));
    _repository.getChildrenByTutor(tutorId).listen(
      (list) => emit(state.copyWith(children: list, isLoading: false)),
      onError: (e) => emit(state.copyWith(error: e.toString(), isLoading: false)),
    );
  }

  Future<void> addChild(Child child) async {
    try {
      await _repository.createChild(child);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> linkChild(String childId, String tutorId) async {
    try {
      await _repository.linkChildWithTutor(childId, tutorId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      throw Exception(e); 
    }
  }

  // --- NUEVA FUNCIÓN PARA BORRAR ---
  Future<void> removeChild(Child child, String tutorId) async {
    try {
      await _repository.removeChild(child.id, tutorId, child.tutorIds);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
  
  void clearSelection() {
    emit(state.copyWith(selectedChild: null));
  }
}