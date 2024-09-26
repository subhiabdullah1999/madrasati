import 'package:eschool/cubits/downloadFeeReceiptCubit.dart';
import 'package:eschool/data/models/childFeeDetails.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

class DownloadReceiptDialog extends StatefulWidget {
  final ChildFeeDetails childFeeDetails;
  final Student child;
  const DownloadReceiptDialog(
      {super.key, required this.child, required this.childFeeDetails});

  @override
  State<DownloadReceiptDialog> createState() => _DownloadReceiptDialogState();
}

class _DownloadReceiptDialogState extends State<DownloadReceiptDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<DownloadFeeReceiptCubit>().downloadFeeReceipt(
          childId: widget.child.id ?? 0, feeId: widget.childFeeDetails.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadFeeReceiptCubit, DownloadFeeReceiptState>(
      listener: (context, state) {
        if (state is DownloadFeeReceiptSuccess) {
          Navigator.of(context).pop();
          OpenFilex.open(state.downloadedFilePath);
        } else if (state is DownloadFeeReceiptFailure) {
          Utils.showCustomSnackBar(
              context: context,
              errorMessage:
                  Utils.getTranslatedLabel(context, state.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error);
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            CustomCircularProgressIndicator(
              widthAndHeight: 15.0,
              strokeWidth: 2.0,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10.0),
            Flexible(
                child: Text(
              Utils.getTranslatedLabel(context, downloadingFeeReceiptKey),
              style: TextStyle(fontSize: 15.0),
            )),
          ],
        ),
      ),
    );
  }
}
