import 'package:eschool/data/models/childFeeDetails.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';

class FeeInformationContainer extends StatelessWidget {
  final ChildFeeDetails childFeeDetails;
  final Student child;
  const FeeInformationContainer(
      {super.key, required this.child, required this.childFeeDetails});

  @override
  Widget build(BuildContext context) {
    final valueTextStyle = TextStyle(
        fontSize: 13.0,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.9));
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            child.getFullName(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 16.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            child: Text(
              childFeeDetails.name ?? "",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Row(
            children: [
              Text(
                "${Utils.getTranslatedLabel(context, classKey)} : ${childFeeDetails.classDetails?.name ?? '-'}",
                style: valueTextStyle,
              ),
              const Spacer(),
              Text(
                childFeeDetails.sessionYear?.name ?? "",
                style: valueTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 2.5),
        ],
      ),
    );
  }
}
