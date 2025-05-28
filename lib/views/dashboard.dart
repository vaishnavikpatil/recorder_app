import 'package:flutter/services.dart';
import 'package:recorder_app/exports.dart';
import 'package:intl/intl.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});



  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    final formattedSecs = secs.toString().padLeft(2, '0');
    return minutes > 0 ? '$minutes:$formattedSecs min' : '0:$formattedSecs sec';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingProvider>(
      builder: (context, provider, _) {
        final recordings = provider.recordings;
        final selectedIds = provider.selectedIds;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              title: Text(
                selectedIds.isNotEmpty
                    ? '${selectedIds.length} selected'
                    : 'Voice Recorder',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white,
              actions: selectedIds.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.checklist),
                        onPressed: provider.selectAll,
                        tooltip: 'Select All',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: provider.deleteSelected,
                        tooltip: 'Delete Selected',
                      ),
                    ]
                  : [],
            ),
          ),
          body: recordings.isEmpty
              ? Center(
                  child: Text(
                    "No recordings found.",
                    style: AppTextStyles.noData,
                  ),
                )
              : ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: recordings.length,
                  itemBuilder: (context, index) {
                    final rec = recordings[index];
                    final fileName = rec.filePath.split('/').last;
                    final isSelected = selectedIds.contains(rec.id);

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 6.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: isSelected
                          ? AppDecorations.card.copyWith(
                              color: AppColors.iconContainer.withOpacity(0.3),
                            )
                          : AppDecorations.card,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onLongPress: (){ 
                            HapticFeedback.selectionClick(); 
                          provider.selectItem(rec.id!);},
                        onTap: () {
                          if (selectedIds.isNotEmpty) {
                            provider.toggleSelection(rec.id!);
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) => AudioPlayerDialog(
                                filePath: rec.filePath,
                                title: fileName,
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15.r),
                              decoration: AppDecorations.iconContainer,
                              child: Image.asset(
                                "assets/icons/microphone_red.png",
                                height: 25.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fileName,
                                    style: AppTextStyles.fileName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${formatDuration(rec.duration)} • ${DateFormat('dd/MM/yyyy').format(DateTime.parse(rec.timestamp))}',
                                    style: AppTextStyles.durationAndSize,
                                  ),
                                ],
                              ),
                            ),
                            isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.primaryText,
                                    size: 25.sp,
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        
        );
      },
    );
  }
}
