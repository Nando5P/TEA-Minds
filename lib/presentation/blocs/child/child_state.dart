import '../../../domain/entities/child_entity.dart';

class ChildState {
  final List<Child> children;
  final Child? selectedChild; // El niño que está jugando actualmente
  final bool isLoading;
  final String? error;

  ChildState({
    this.children = const [],
    this.selectedChild,
    this.isLoading = false,
    this.error,
  });

  // Método para crear una copia del estado cambiando solo lo que necesitemos
  ChildState copyWith({
    List<Child>? children,
    Child? selectedChild,
    bool? isLoading,
    String? error,
  }) {
    return ChildState(
      children: children ?? this.children,
      selectedChild: selectedChild ?? this.selectedChild, // Permitimos que sea null
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}