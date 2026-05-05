import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/child_entity.dart'; // Importamos la entidad
import '../../../domain/repositories/child_repository.dart';

// Estados del Cubit
abstract class ChildState {}

class ChildInitial extends ChildState {}

class ChildLoading extends ChildState {}

class ChildLoaded extends ChildState {
  // Ahora manejamos una lista de la entidad Child para ser consistentes con el Repositorio
  final List<Child> children;
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
  // Cambiamos el parámetro a Child (entidad) para que encaje con la interfaz del repositorio
  Future<void> addChild(Child child) async {
    try {
      await _childRepository.createChild(child);
    } catch (e) {
      emit(ChildError("No se pudo crear el pollito: $e"));
    }
  }
}