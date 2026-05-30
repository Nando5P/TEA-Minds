import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/repositories/child_repository.dart';
import '../../core/theme/teaColors.dart';
import '../../core/widgets/tea_snackbars.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/child/child_cubit.dart';
import 'child_hub_page.dart';
import 'create_child_dialog.dart';
import 'tutor_stats_page.dart';

class TutorDashboardPage extends StatelessWidget {
  const TutorDashboardPage({super.key});

  @override
  Widget build(BuildContext mainContext) {
    final authState = mainContext.read<AuthCubit>().state;
    final String tutorId = (authState is AuthAuthenticated)
        ? authState.user.uid
        : '';

    return Scaffold(
      backgroundColor: TEAColors.background,
      appBar: AppBar(
        title: const Text(
          'Mis Pollitos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: TEAColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => mainContext.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<Child>>(
        stream: mainContext.read<ChildRepository>().getChildrenByTutor(tutorId),
        builder: (streamContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(mainContext);
          }

          final children = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
            ),
            itemCount: children.length,
            itemBuilder: (gridContext, index) {
              final child = children[index];
              return _buildChildCard(mainContext, child, tutorId);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: mainContext,
          builder: (dialogContext) => const CreateChildDialog(),
        ),
        backgroundColor: TEAColors.bluePastel,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Pollito',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, Child child, String tutorId) {
    final colorHex = child.color.toUpperCase();
    String colorName = 'orange'; // Imagen por defecto

    if (colorHex.contains('BBDEFB')) {
      colorName = 'blue';
    } else if (colorHex.contains('E1BEE7')) {
      colorName = 'purple';
    } else if (colorHex.contains('F8BBD0')) {
      colorName = 'red';
    } else if (colorHex.contains('C8E6C9') || colorHex.contains('A5D6A7')) {
      colorName = 'green';
    }

    return GestureDetector(
      onTap: () => _showActionMenu(context, child, tutorId),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pollitos/$colorName.png',
              width: 80,
              height: 80,
              // Si falla la carga de la imagen, se muestra un huevo amarillo de seguridad
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.egg, size: 80, color: Colors.amber),
            ),
            const SizedBox(height: 15),
            Text(
              child.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: TEAColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context, Child child, String tutorId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Qué quieres hacer con ${child.nombre}?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: TEAColors.bluePastel,
                  child: Icon(Icons.play_arrow, color: Colors.white),
                ),
                title: const Text(
                  'Ir a jugar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Acceder al panel de juegos'),
                onTap: () {
                  Navigator.pop(modalContext);
                  context.read<ChildCubit>().selectChild(child);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChildHubPage(child: child),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.bar_chart, color: Colors.orange),
                ),
                title: const Text(
                  'Ver progreso',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Estadísticas y aciertos'),
                onTap: () {
                  Navigator.pop(modalContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TutorStatsPage(child: child),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: TEAColors.chickyYellow,
                  child: Icon(Icons.copy, color: TEAColors.textPrimary),
                ),
                title: const Text(
                  'Copiar ID del pollito',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Comparte este código para vincularlo'),
                onTap: () {
                  Navigator.pop(modalContext);
                  Clipboard.setData(ClipboardData(text: child.id));
                  TEASnackBars.show(
                    context,
                    message:
                        '¡ID de ${child.nombre} copiado al portapapeles! 📋',
                    isError: false,
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: TEAColors.errorPastel,
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
                title: const Text(
                  'Borrar pollito',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                subtitle: const Text('Eliminar o desvincular perfil'),
                onTap: () {
                  Navigator.pop(modalContext);
                  _showDeleteConfirmation(context, child, tutorId);
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext safeContext,
    Child child,
    String tutorId,
  ) {
    final bool isOnlyTutor = child.tutorIds.length <= 1;
    final String title = isOnlyTutor
        ? '¿Borrar perfil?'
        : '¿Desvincular perfil?';
    final String content = isOnlyTutor
        ? 'Eres el único tutor de ${child.nombre}. Si lo borras, sus datos y estadísticas se perderán para siempre.'
        : 'Compartes a ${child.nombre} con otros tutores. Solo se eliminará de tu lista, pero los demás podrán seguir viéndolo.';

    showDialog(
      context: safeContext,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TEAColors.textPrimary,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(color: TEAColors.textSecondary, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: TEAColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Cerramos el diálogo flotante

              // Mostramos el SnackBar de despedida
              TEASnackBars.show(
                safeContext,
                message: 'Adiós, ${child.nombre} 🐣',
                isError: false,
              );

              // Disparamos la lógica de Firebase
              safeContext.read<ChildCubit>().removeChild(child, tutorId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TEAColors.errorPastel,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐣', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 20),
          const Text(
            'No tienes pollitos registrados',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
