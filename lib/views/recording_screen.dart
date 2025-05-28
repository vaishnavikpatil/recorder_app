import 'package:lottie/lottie.dart';
import 'package:recorder_app/exports.dart';


class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Voice Recorder',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryText,
        actions: [
          IconButton(onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Dashboard()),
            ), icon:const Icon(Icons.more_horiz))
        ],
      ),
      body: Center(
        child: Consumer<RecordingProvider>(
          builder: (context, provider, _) {
            if (provider.isRecording) {
              _lottieController.repeat();
            } else {
              _lottieController.stop();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (provider.isRecording) {
                      await provider.stopRecording();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recording saved')),
                        );
               
                      }
                    } else {
                      await provider.startRecording();
                    }
                  },
                  child: Lottie.asset(
                    "assets/lottie_files/play_button.json",
                    controller: _lottieController,
                    onLoaded: (composition) {
                      _lottieController.duration = composition.duration;
                      if (provider.isRecording) {
                        _lottieController.repeat();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  provider.status,
                  style: const TextStyle(fontSize: 24, color: AppColors.primaryText),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
