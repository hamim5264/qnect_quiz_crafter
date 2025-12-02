class QuestionModel {
  final String id;
  final String quizId;
  final int index;
  final String text;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption; // 'A' | 'B' | 'C' | 'D'
  final String explanation;
  final String? qcVaultId; // if imported

  QuestionModel({
    required this.id,
    required this.quizId,
    required this.index,
    required this.text,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.explanation,
    this.qcVaultId,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'index': index,
      'text': text,
      'optionA': optionA.toLowerCase(),
      'optionB': optionB.toLowerCase(),
      'optionC': optionC.toLowerCase(),
      'optionD': optionD.toLowerCase(),
      'correctOption': correctOption,
      'explanation': explanation,
      'qcVaultId': qcVaultId,
      // we usually don't store `id` inside doc, Firestore doc id is enough
    };
  }

  factory QuestionModel.fromJson(String id, Map<String, dynamic> data) {
    return QuestionModel(
      id: id,
      quizId: data['quizId'] as String,
      index: data['index'] as int,
      text: data['text'] as String,
      optionA: data['optionA'] as String,
      optionB: data['optionB'] as String,
      optionC: data['optionC'] as String,
      optionD: data['optionD'] as String,
      correctOption: data['correctOption'] as String,
      explanation: data['explanation'] as String? ?? '',
      qcVaultId: data['qcVaultId'] as String?,
    );
  }

  // ✅ added this
  QuestionModel copyWith({
    String? id,
    String? quizId,
    int? index,
    String? text,
    String? optionA,
    String? optionB,
    String? optionC,
    String? optionD,
    String? correctOption,
    String? explanation,
    String? qcVaultId,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      index: index ?? this.index,
      text: text ?? this.text,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctOption: correctOption ?? this.correctOption,
      explanation: explanation ?? this.explanation,
      qcVaultId: qcVaultId ?? this.qcVaultId,
    );
  }
}
