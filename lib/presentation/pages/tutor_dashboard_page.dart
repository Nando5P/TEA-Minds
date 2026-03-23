import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/teaColors.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/child/child_cubit.dart';
import 'create_child_dialog.dart';

class TutorDashboardPage extends StatefulWidget {
  const TutorDashboardPage({super.key});

  @override
  State<TutorDashboardPage> createState() => _TutorDashboardPageState();
}

class _TutorDashboardPageState extends State<TutorDashboardPage> {
  
  @override
  void initState() {
    super.initState();
    // Al arrancar, le pedimos al Cubit que vigile los niños del tutor actual
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<ChildCubit>().watchChildren(authState.user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TEAColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<ChildCubit, ChildState>(
              builder: (context, state) {
                if (state is ChildLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChildLoaded) {
                  return state.children.isEmpty
                      ? _buildEmptyState(context)
                      : _buildChildrenGrid(context, state.children);
                } else if (state is ChildError) {
                  return Center(child: Text(state.message));
                }
                return _buildEmptyState(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: TEAColors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text('🐤', style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Text('TEA-Minds',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: TEAColors.textPrimary),
                ),
              ],
            ),
            IconButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              icon: const Icon(Icons.logout, color: TEAColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenGrid(BuildContext context, List<dynamic> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mis Pollitos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: TEAColors.textPrimary),
              ),
              _buildAddButton(context),
            ],
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columnas como en tus ejemplos móviles
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.85,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) => _ChildCard(child: children[index]),
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
          const SizedBox(height: 16),
          const Text('Aún no tienes ningún pollito',
            style: TextStyle(fontSize: 18, color: TEAColors.textSecondary),
          ),
          const SizedBox(height: 24),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const CreateChildDialog(),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Añadir'),
      style: ElevatedButton.styleFrom(
        backgroundColor: TEAColors.greenPastel,
        foregroundColor: TEAColors.textPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// Widget de Tarjeta Individual
class _ChildCard extends StatelessWidget {
  final dynamic child;
  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    // Convertimos el String Hex de la DB a objeto Color de Flutter
    final Color chickColor = Color(int.parse(child.color.replaceFirst('#', '0xFF')));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: chickColor, shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text('🐤', style: TextStyle(fontSize: 40)),
                if (child.tieneGafas) 
                  const Text('👓', style: TextStyle(fontSize: 35)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(child.nombre,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: TEAColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text('Ver progreso', style: TextStyle(fontSize: 12, color: TEAColors.bluePastel)),
        ],
      ),
    );
  }
}