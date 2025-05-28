class Recording {
  final int? id;
  final String filePath;
  final String timestamp;
  final int duration;

  Recording({
    this.id,
    required this.filePath,
    required this.timestamp,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'timestamp': timestamp,
      'duration': duration,
    };
  }

  static Recording fromMap(Map<String, dynamic> map) {
    return Recording(
      id: map['id'],
      filePath: map['filePath'],
      timestamp: map['timestamp'],
      duration: map['duration'],
    );
  }
}
