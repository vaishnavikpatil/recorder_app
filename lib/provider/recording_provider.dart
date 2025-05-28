import 'dart:async';
import 'dart:io';

import 'package:recorder_app/exports.dart';

class RecordingProvider extends ChangeNotifier with WidgetsBindingObserver {
  final AudioRecorderService _recorder = AudioRecorderService();
  final DatabaseService _db = DatabaseService();

  List<Recording> _recordings = [];
  List<Recording> get recordings => _recordings;

  Set<int> _selectedIds = {};
  Set<int> get selectedIds => _selectedIds;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  String? _currentFilePath;
  String? get currentFilePath => _currentFilePath;

  int _duration = 0;
  int get duration => _duration;

  Timer? _timer;

  String get status => _isRecording ? 'Recording... ${_formatDuration(_duration)}' : 'Stopped';

  RecordingProvider() {
    WidgetsBinding.instance.addObserver(this);
    loadRecordings();
  }


  Future<void> loadRecordings() async {
    _recordings = await _db.getRecordings();
    notifyListeners();
  }

  void selectItem(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void toggleSelection(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }

  void selectAll() {
    _selectedIds = _recordings.map((r) => r.id!).toSet();
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    for (var id in _selectedIds) {
      final rec = _recordings.firstWhere((r) => r.id == id);
      await _db.deleteRecording(id);
      try {
        final file = File(rec.filePath);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
    clearSelection();
    await loadRecordings();
  }

  Future<void> startRecording() async {
    if (_isRecording) return;
    final path = await _recorder.startRecording();
    if (path != null) {
      _currentFilePath = path;
      _isRecording = true;
      _duration = 0;
      _startTimer();
      notifyListeners();
    }
  }


  Future<void> stopRecording() async {
    if (!_isRecording) return;

    final result = await _recorder.stopRecording();

    if (result != null && _currentFilePath != null) {
      final rec = Recording(
        filePath: _currentFilePath!,
        timestamp: DateTime.now().toIso8601String(),
        duration: result['duration'],
      );

      await _db.insertRecording(rec);
      await loadRecordings();
    }

    _isRecording = false;
    _stopTimer();
    _duration = 0;
    _currentFilePath = null;
    notifyListeners();
  }

void _startTimer() {
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
    _duration++;
    notifyListeners();


  });
}


  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}
