class EnglishWord {
  String? id;
  String? letter;
  String? after;
  String? noun;
  String? quote;
  bool isFavorite;

  EnglishWord({
    this.id, 
    this.letter, 
    this.after, 
    this.noun, 
    this.quote, 
    this.isFavorite = false
  });
}