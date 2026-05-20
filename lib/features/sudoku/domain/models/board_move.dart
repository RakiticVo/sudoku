class BoardMove {
  final int timestampOffsetMs;
  final int row;
  final int col;
  final int val;
  final bool isNote;

  const BoardMove({
    required this.timestampOffsetMs,
    required this.row,
    required this.col,
    required this.val,
    required this.isNote,
  });

  Map<String, dynamic> toJson() => {
        't': timestampOffsetMs,
        'r': row,
        'c': col,
        'v': val,
        'n': isNote ? 1 : 0,
      };

  factory BoardMove.fromJson(Map<String, dynamic> json) => BoardMove(
        timestampOffsetMs: json['t'] as int,
        row: json['r'] as int,
        col: json['c'] as int,
        val: json['v'] as int,
        isNote: (json['n'] as int) == 1,
      );
}
