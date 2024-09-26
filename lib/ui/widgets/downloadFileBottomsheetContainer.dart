import 'package:eschool/cubits/downloadFileCubit.dart';
import 'package:eschool/data/models/studyMaterial.dart';
import 'package:eschool/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:eschool/ui/widgets/customRoundedButton.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadFileBottomsheetContainer extends StatefulWidget {
  final StudyMaterial studyMaterial;
  final bool storeInExternalStorage;

  const DownloadFileBottomsheetContainer({
    Key? key,
    required this.studyMaterial,
    required this.storeInExternalStorage,
  }) : super(key: key);

  @override
  State<DownloadFileBottomsheetContainer> createState() =>
      _DownloadFileBottomsheetContainerState();
}

class _DownloadFileBottomsheetContainerState
    extends State<DownloadFileBottomsheetContainer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<DownloadFileCubit>().downloadFile(
            studyMaterial: widget.studyMaterial,
            storeInExternalStorage: widget.storeInExternalStorage,
          );
    });
  }

  Widget _buildProgressContainer({
    required double width,
    required Color color,
  }) {
    return Container(
      width: width,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(3.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        if (context.read<DownloadFileCubit>().state is DownloadFileInProgress) {
          context.read<DownloadFileCubit>().cancelDownloadProcess();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.075),
          vertical: MediaQuery.of(context).size.height * (0.04),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Utils.bottomSheetTopRadius),
            topRight: Radius.circular(Utils.bottomSheetTopRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomsheetTopTitleAndCloseButton(
              onTapCloseButton: () {
                if (context.read<DownloadFileCubit>().state
                    is DownloadFileInProgress) {
                  context.read<DownloadFileCubit>().cancelDownloadProcess();
                }
                Navigator.of(context).pop();
              },
              titleKey: fileDownloadingKey,
            ),

            //
            Text(
              widget.studyMaterial.fileName,
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.0125),
            ),
            BlocConsumer<DownloadFileCubit, DownloadFileState>(
              listener: (context, state) {
                if (state is DownloadFileSuccess) {
                  Navigator.of(context).pop(
                    {"error": false, "filePath": state.downloadedFileUrl},
                  );
                } else if (state is DownloadFileFailure) {
                  Navigator.of(context)
                      .pop({"error": true, "message": state.errorMessage});
                }
              },
              builder: (context, state) {
                if (state is DownloadFileInProgress) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6,
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            return Stack(
                              children: [
                                _buildProgressContainer(
                                  width: boxConstraints.maxWidth,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5),
                                ),
                                _buildProgressContainer(
                                  width: boxConstraints.maxWidth *
                                      state.uploadedPercentage *
                                      0.01,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${state.uploadedPercentage.toStringAsFixed(2)} %",
                      )
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            CustomRoundedButton(
              onTap: () {
                context.read<DownloadFileCubit>().cancelDownloadProcess();
                Navigator.of(context).pop();
              },
              height: 40,
              textSize: 16.0,
              widthPercentage: 0.35,
              titleColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: Theme.of(context).colorScheme.primary,
              buttonTitle: Utils.getTranslatedLabel(context, cancelKey),
              showBorder: false,
            )
          ],
        ),
      ),
    );
  }
}
