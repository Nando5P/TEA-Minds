import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/child_repository.dart';
import '../../../data/models/child_model.dart';

// Estados del Cubit
abstract class ChildState {}
class ChildInitial extends ChildState {}
class ChildLoading extends ChildState {}
class ChildLoaded extends ChildState {
  final List<ChildModel> children;
  ChildLoaded(this.children);
}
class ChildError extends ChildState {
  final String message;
  ChildError(this.message);
}

class ChildCubit extends Cubit<ChildState> {
  final ChildRepository _childRepository;

  ChildCubit(this._childRepository) : super(ChildInitial());

  // Escuchar los niños de un tutor en tiempo real
  void watchChildren(String tutorId) {
    emit(ChildLoading());
    _childRepository.getChildrenByTutor(tutorId).listen(
      (children) => emit(ChildLoaded(children)),
      onError: (e) => emit(ChildError("Error al cargar pollitos: $e")),
    );
  }

  // Crear un nuevo niño
  Future<void> addChild(ChildModel child) async {
    try {
      await _childRepository.createChild(child);
    } catch (e) {
      emit(ChildError("No se pudo crear el pollito: $e"));
    }
  }
}