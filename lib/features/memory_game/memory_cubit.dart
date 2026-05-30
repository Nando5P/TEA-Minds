import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';

class MemoryCard {
  final int id;
  final String emoji; 
  bool isFlipped;
  bool isMatched;

  MemoryCard({required this.id, required this.emoji, this.isFlipped = false, this.isMatched = false});
}

class MemoryState {
  final List<MemoryCard> cards;
  final List<int> flippedIndices;
  final bool isWin;

  MemoryState({required this.cards, this.flippedIndices = const [], this.isWin = false});
}

class MemoryCubit extends Cubit<MemoryState> {
  final Child child;

  MemoryCubit({required this.child}) : super(MemoryState(cards: []));

  void initGame() {
    List<String> emojis = ['🐶', '🐱', '🐘', '🐯', '🦁', '🐷']; // , '🐸', '🐵', '🐔', '🐧'
    List<String> items = [...emojis, ...emojis]..shuffle();
    
    List<MemoryCard> cards = List.generate(
      items.length, 
      (i) => MemoryCard(id: i, emoji: items[i])
    );
    
    emit(MemoryState(cards: cards, isWin: false));
  }

  void flipCard(int index) async {
    if (state.cards[index].isFlipped || state.cards[index].isMatched || state.flippedIndices.length == 2) return;

    final cards = List<MemoryCard>.from(state.cards);
    cards[index].isFlipped = true;
    final flipped = List<int>.from(state.flippedIndices)..add(index);

    emit(MemoryState(cards: cards, flippedIndices: flipped));

    if (flipped.length == 2) {
      final first = cards[flipped[0]];
      final second = cards[flipped[1]];

      if (first.emoji == second.emoji) {
        first.isMatched = true;
        second.isMatched = true;
        
        final win = cards.every((c) => c.isMatched);
        emit(MemoryState(cards: cards, flippedIndices: [], isWin: win));
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
        first.isFlipped = false;
        second.isFlipped = false;
        emit(MemoryState(cards: cards, flippedIndices: []));
      }
    }
  }
}