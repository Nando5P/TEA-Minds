import '../../../domain/entities/child_entity.dart';

class ChildState {
  final List<Child> children;
  final Child? selectedChild;
  final bool isLoading;
  final String? error;

  ChildState({
    this.children = const [],
    this.selectedChild,
    this.isLoading = false,
    this.error,
  });

  ChildState copyWith({
    List<Child>? children,
    Child? selectedChild,
    bool? isLoading,
    String? error,
  }) {
    return ChildState(
      children: children ?? this.children,
      selectedChild: selectedChild ?? this.selectedChild,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}