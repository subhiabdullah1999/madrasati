import 'package:eschool/cubits/paymentTransactionsCubit.dart';
import 'package:eschool/data/repositories/paymentRepository.dart';
import 'package:eschool/ui/widgets/customAppbar.dart';
import 'package:eschool/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/utils/constants.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<PaymentTransactionsCubit>(
            create: (_) => PaymentTransactionsCubit(PaymentRepository()),
          ),
        ],
        child: const TransactionsScreen(),
      ),
    );
  }

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<PaymentTransactionsCubit>().fetchPaymentTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BlocBuilder<PaymentTransactionsCubit, PaymentTransactionsState>(
            builder: (context, state) {
          if (state is PaymentTransactionsFetchSuccess) {
            return ListView.builder(
                itemCount: state.paymentTransactions.length,
                padding: EdgeInsets.only(
                  bottom: 25.0,
                  left: Utils.screenContentHorizontalPadding,
                  right: Utils.screenContentHorizontalPadding,
                  top: Utils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          Utils.appBarSmallerHeightPercentage),
                ),
                itemBuilder: (context, index) {
                  final transaction = state.paymentTransactions[index];

                  Color transactionStatusColor =
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5);
                  if (transaction.paymentStatus ==
                      succeedTransactionStatusKey) {
                    transactionStatusColor =
                        Theme.of(context).colorScheme.onSecondary;
                  } else if (transaction.paymentStatus ==
                      failedTransactionStatusKey) {
                    transactionStatusColor =
                        Theme.of(context).colorScheme.error;
                  }

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "#${transaction.id}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.5)),
                            ),
                            const Spacer(),
                            (transaction.createdAt ?? "").isEmpty
                                ? const SizedBox()
                                : Text(
                                    Utils.formatDate(
                                        DateTime.parse(transaction.createdAt!)
                                            .toLocal()),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.5)),
                                  ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              TimeOfDay.fromDateTime(DateTime.parse(
                                          transaction.createdAt ??
                                              DateTime.now().toIso8601String())
                                      .toLocal())
                                  .format(context),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.5)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "${transaction.school?.name ?? '-'}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Row(
                          children: [
                            Text(
                              "${transaction.currencySymbol}${(transaction.amount ?? 0).toString()}",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0),
                            ),
                            const Spacer(),
                            Text(
                              Utils.getTranslatedLabel(
                                  context, transaction.paymentStatus ?? ""),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: transactionStatusColor),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(Utils.getTranslatedLabel(
                            context, transactionIdKey)),
                        Text(
                          "${transaction.orderId}",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.75)),
                        )
                      ],
                    ),
                  );
                });
          }

          if (state is PaymentTransactionsFetchFailure) {
            return Center(
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                animate: true,
                onTapRetry: () {
                  context
                      .read<PaymentTransactionsCubit>()
                      .fetchPaymentTransactions();
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
            title: Utils.getTranslatedLabel(context, transactionsKey),
          ),
        ),
      ],
    ));
  }
}
