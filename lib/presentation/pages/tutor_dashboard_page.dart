import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/repositories/child_repository.dart';
import '../../models/teaColors.dart'; // Mantengo tu nombre de archivo actual
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/child/child_cubit.dart';
import 'child_hub_page.dart'; 
import 'create_child_dialog.dart';
import 'tutor_stats_page.dart';

class TutorDashboardPage extends StatelessWidget {
  const TutorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final String tutorId = (authState is AuthAuthenticated) ? authState.user.uid : '';

    return Scaffold(
      backgroundColor: TEAColors.background,
      appBar: AppBar(
        title: const Text('Mis Pollitos', 
          style: TextStyle(fontWeight: FontWeight.bold, color: TEAColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<Child>>(
        stream: context.read<ChildRepository>().getChildrenByTutor(tutorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context);
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
            itemBuilder: (context, index) {
              final child = children[index];
              return _buildChildCard(context, child);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const CreateChildDialog(),
        ),
        backgroundColor: TEAColors.bluePastel,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nuevo Pollito', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, Child child) {
    final Color cardColor = Color(int.parse(child.color.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () => _showActionMenu(context, child), 
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
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  child.tieneGafas ? '🐥👓' : '🐥',
                  style: const TextStyle(fontSize: 45),
                ),
              ],
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

  void _showActionMenu(BuildContext context, Child child) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Qué quieres hacer con ${child.nombre}?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: TEAColors.bluePastel,
                  child: Icon(Icons.play_arrow, color: Colors.white),
                ),
                title: const Text('Ir a jugar', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Acceder al panel de juegos'),
                onTap: () {
                  Navigator.pop(context); 
                  
                  // 1. Seleccionamos al niño en el Cubit
                  context.read<ChildCubit>().selectChild(child); 
                  
                  // 2. CORRECCIÓN: Pasamos el child y quitamos el const
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildHubPage(child: child),
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
                title: const Text('Ver progreso', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Estadísticas y aciertos'),
                onTap: () {
                  Navigator.pop(context); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TutorStatsPage(child: child)),
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐣', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 20),
          const Text('No tienes pollitos registrados', 
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}