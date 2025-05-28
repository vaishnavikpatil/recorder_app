
import 'exports.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => RecordingProvider()..loadRecordings()),
          ],
          child: MaterialApp(
            title: 'Flutter Recorder App',
            home:const  RecordingScreen(),
            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
          ),
        );
      },
    );
  }
}