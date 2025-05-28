
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  DateTime? _startTime;

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/recording_$timestamp.m4a';
  }

  Future<String?> startRecording() async {
    if (await hasPermission()) {
      final path = await _getFilePath();
      _startTime = DateTime.now();

      final config =  RecordConfig(
        encoder: AudioEncoder.aacLc, 
        bitRate: 128000,
        sampleRate: 44100,
      );

      await _recorder.start(config, path: path);
      return path;
    }
    return null;
  }

  Future<Map<String, dynamic>?> stopRecording() async {
    if (!await _recorder.isRecording()) return null;

    final path = await _recorder.stop();
    final endTime = DateTime.now();

    if (_startTime == null || path == null) return null;

    final duration = endTime.difference(_startTime!).inSeconds;
    final result = {
      'path': path,
      'duration': duration,
    };

    _startTime = null;

    return result;
  }

  Future<void> cancelRecording() async {
    await _recorder.cancel();
    _startTime = null;
  }

  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }

  void dispose() {
    _recorder.dispose();
  }
}
