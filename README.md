# Recorder App

## How to Run

1. Install Flutter.  
2. Clone the repo or extract the ZIP.  
3. Run `flutter pub get`.  
4. Run with `flutter run`.  

## Screenshots

| Dashboard Screen | Recordings Screen |
|------------------|-------------------|
| ![Dashboard](https://github.com/user-attachments/assets/9c87d55f-bbd1-44fd-a45b-4be8c82365c0) | ![Recordings](https://github.com/user-attachments/assets/9e5c5463-5de4-4dd1-b0b6-0a999273506a) |

## Dependencies

### Packages Used

- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)  
- [intl](https://pub.dev/packages/intl)  
- [path](https://pub.dev/packages/path)  
- [path_provider](https://pub.dev/packages/path_provider)  
- [provider](https://pub.dev/packages/provider)  
- [record](https://pub.dev/packages/record)  
- [sqflite](https://pub.dev/packages/sqflite)  
- [lottie](https://pub.dev/packages/lottie)  
- [just_audio](https://pub.dev/packages/just_audio)  
- [workmanager](https://pub.dev/packages/workmanager)  
- [permission_handler](https://pub.dev/packages/permission_handler)  


## Limitations & Edge Case Handling

- Files are saved locally when the recording is stopped normally.  
- The app successfully handles recording while running in the background, when paused, and when the phone is locked.  
- Users can view, select, and delete saved recordings.  
- Tried using the `workmanager` package to support background tasks during recording.  
- Tried implementing chunked audio data storage to reduce data loss during recording.  
- Full recovery on unexpected app termination is a known limitation.  

## Directory Structure

- `views/` – UI  
- `services/` – Logic (DB and Recording)  
- `models/` – Data models  
- `utils/` – Utilities  
- `widgets/` – Reusable widgets  
