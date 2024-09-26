import 'package:eschool/cubits/schoolConfigurationCubit.dart';
import 'package:eschool/data/models/advanceFee.dart';
import 'package:eschool/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvanceInstallmentPaidAmountBottomsheet extends StatelessWidget {
  final List<AdvanceFee> advanceFees;
  const AdvanceInstallmentPaidAmountBottomsheet(
      {super.key, required this.advanceFees});

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context
            .read<SchoolConfigurationCubit>()
            .getSchoolConfiguration()
            .schoolSettings
            .currencySymbol ??
        '';
    double totalAdvancePaidAmount = 0.0;
    for (var advanceFee in advanceFees) {
      totalAdvancePaidAmount =
          totalAdvancePaidAmount + (advanceFee.amount ?? 0.0);
    }

    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.075),
          vertical: MediaQuery.of(context).size.height * (0.04),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomsheetTopTitleAndCloseButton(
              onTapCloseButton: () {
                Navigator.of(context).pop();
              },
              titleKey: Utils.getTranslatedLabel(
                  context, advancePaidAmountDetailsKey),
            ),
            Row(
              children: [
                Text(
                  Utils.getTranslatedLabel(context, totalAmountKey),
                  style: TextStyle(fontSize: 16.0),
                ),
                const Spacer(),
                Text(
                  "${currencySymbol}${totalAdvancePaidAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const Divider(),
            ...advanceFees
                .map((advanceFee) => Column(
                      children: [
                        SizedBox(
                          height: 35,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              "$currencySymbol${(advanceFee.amount ?? 0).toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 15),
                            ),
                            subtitle: Text(
                              "${Utils.getTranslatedLabel(context, paidOnKey)} ${Utils.formatDate(DateTime.parse(advanceFee.createdAt!))}",
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
