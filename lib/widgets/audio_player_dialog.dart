import 'package:recorder_app/exports.dart';


class AudioPlayerDialog extends StatefulWidget {
  final String filePath;
  final String title;

  const AudioPlayerDialog({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  State<AudioPlayerDialog> createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  late final AudioPlayer _player;

  final ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.durationStream.listen((dur) {
      if (dur != null) _duration.value = dur;
    });

    _player.positionStream.listen((pos) {
      _position.value = pos;
    });

    _initAndPlay();
  }

  Future<void> _initAndPlay() async {
    try {
      await _player.setFilePath(widget.filePath);
      await _player.play();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load audio')),
        );
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _position.dispose();
    _duration.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes;
    final sec = d.inSeconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _player.stop();
        return true;
      },
      child: AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(widget.title, overflow: TextOverflow.ellipsis)),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await _player.stop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<Duration>(
              valueListenable: _duration,
              builder: (context, duration, _) {
                return ValueListenableBuilder<Duration>(
                  valueListenable: _position,
                  builder: (context, position, __) {
                    final maxVal = duration.inMilliseconds.toDouble();
                    final posVal = position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble();
                    return Slider(
                      min: 0,
                      max: maxVal > 0 ? maxVal : 1,
                      value: posVal,
                      onChanged: (val) => _player.seek(Duration(milliseconds: val.toInt())),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<Duration>(
                    valueListenable: _position,
                    builder: (_, pos, __) => Text(_formatDuration(pos)),
                  ),
                  ValueListenableBuilder<Duration>(
                    valueListenable: _duration,
                    builder: (_, dur, __) => Text(_formatDuration(dur)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
