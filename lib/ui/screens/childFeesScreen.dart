import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/childFeeDetailsCubit.dart';
import 'package:eschool/data/models/childFeeDetails.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/ui/widgets/customAppbar.dart';
import 'package:eschool/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildFeesScreen extends StatefulWidget {
  final Student child;
  ChildFeesScreen({Key? key, required this.child}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => ChildFeesScreen(
        child: routeSettings.arguments as Student,
      ),
    );
  }

  @override
  State<ChildFeesScreen> createState() => _ChildFeesScreenState();
}

class _ChildFeesScreenState extends State<ChildFeesScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchChildFeeDetails();
    });
  }

  void fetchChildFeeDetails() {
    context
        .read<ChildFeeDetailsCubit>()
        .fetchChildFeeDetails(childId: widget.child.id ?? 0);
  }

  Widget _buildFeesContainer({required List<ChildFeeDetails> fees}) {
    return CustomRefreshIndicator(
      displacment: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarSmallerHeightPercentage),
      onRefreshCallback: () async {
        fetchChildFeeDetails();
      },
      child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: 25,
            left: Utils.screenContentHorizontalPadding,
            right: Utils.screenContentHorizontalPadding,
            top: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
            ),
          ),
          itemCount: fees.length,
          itemBuilder: (context, index) {
            final feeDetails = fees[index];
            final valueTextStyle = TextStyle(
                fontSize: 13.0,
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.9));
            final feePaymentStatusKey = feeDetails.getFeePaymentStatus();
            final feePaymentStatusColor = feePaymentStatusKey == pendingKey
                ? Theme.of(context).colorScheme.error
                : (feePaymentStatusKey == paidKey)
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary;
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.childFeeDetails,
                      arguments: {
                        "childFeeDetails": feeDetails,
                        "child": widget.child
                      });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feeDetails.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            "${Utils.getTranslatedLabel(context, classKey)} : ${feeDetails.classDetails?.name ?? '-'}",
                            style: valueTextStyle,
                          ),
                          const Spacer(),
                          Text(
                            feeDetails.sessionYear?.name ?? "",
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.5),
                      Row(
                        children: [
                          Text(
                            "${Utils.getTranslatedLabel(context, statusKey)} : ",
                            style: valueTextStyle,
                          ),
                          Text(
                            Utils.getTranslatedLabel(
                                context, feePaymentStatusKey),
                            style: valueTextStyle.copyWith(
                                color: feePaymentStatusColor),
                          ),
                          const Spacer(),
                          feePaymentStatusKey == paidKey
                              ? const SizedBox()
                              : feeDetails
                                      .didUserPaidPreviousCompulsoryFeeInInstallment()
                                  ? const SizedBox()
                                  : Text(
                                      "${Utils.getTranslatedLabel(context, dueDateKey)} : ${feeDetails.dueDate ?? ''}",
                                      style: valueTextStyle,
                                    ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ChildFeeDetailsCubit, ChildFeeDetailsState>(
              builder: (context, state) {
            if (state is ChildFeeDetailsFetchSuccess) {
              return _buildFeesContainer(fees: state.fees);
            }
            if (state is ChildFeeDetailsFetchFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    fetchChildFeeDetails();
                  },
                ),
              );
            }
            return Center(
              child: CustomCircularProgressIndicator(
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: Utils.getTranslatedLabel(context, feesKey),
            ),
          ),
        ],
      ),
    );
  }
}
