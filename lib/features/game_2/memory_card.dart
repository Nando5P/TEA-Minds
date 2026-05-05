class MemoryCard {
  final String id;
  final String content;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.content,
    this.isFlipped = false,
    this.isMatched = false,
  });
}