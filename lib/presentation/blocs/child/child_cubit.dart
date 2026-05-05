import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/child_entity.dart';
import '../../../domain/repositories/child_repository.dart';
import 'child_state.dart';

class ChildCubit extends Cubit<ChildState> {
  final ChildRepository _repository;

  ChildCubit(this._repository) : super(ChildState());

  // --- LA FUNCIÓN QUE FALTABA ---
  void selectChild(Child child) {
    emit(state.copyWith(selectedChild: child));
  }

  // Cargar lista de niños (opcional si usas Stream directamente, pero útil para el estado global)
  void loadChildren(String tutorId) {
    emit(state.copyWith(isLoading: true));
    _repository.getChildrenByTutor(tutorId).listen(
      (list) => emit(state.copyWith(children: list, isLoading: false)),
      onError: (e) => emit(state.copyWith(error: e.toString(), isLoading: false)),
    );
  }

  // Añadir nuevo niño
  Future<void> addChild(Child child) async {
    try {
      await _repository.createChild(child);
      // No hace falta emitir nada aquí si getChildrenByTutor es un Stream, 
      // ya que se actualizará solo.
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
  
  // Limpiar selección (por si vuelves al dashboard)
  void clearSelection() {
    emit(state.copyWith(selectedChild: null));
  }
}