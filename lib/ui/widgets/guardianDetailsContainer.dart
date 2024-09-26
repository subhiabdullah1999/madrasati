import 'package:eschool/data/models/guardian.dart';
import 'package:eschool/ui/widgets/customUserProfileImageWidget.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';

class GuardianDetailsContainer extends StatelessWidget {
  final Guardian guardian;
  const GuardianDetailsContainer({
    Key? key,
    required this.guardian,
  }) : super(key: key);

  Widget _buildGuardianDetailsTitleAndValue({
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
              fontSize: 13.0,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
              top: -40,
              start: MediaQuery.of(context).size.width * (0.4) - 35.5,
              child: Container(
                width: 85.0,
                height: 85.0,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: CustomUserProfileImageWidget(
                      profileUrl: guardian.image ?? ""),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Divider(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
                  height: 1.25,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildGuardianDetailsTitleAndValue(
                  title: Utils.getTranslatedLabel(context, nameKey),
                  context: context,
                  value: Utils.formatEmptyValue(
                    guardian.getFullName(),
                  ),
                ),
                _buildGuardianDetailsTitleAndValue(
                  context: context,
                  title: Utils.getTranslatedLabel(context, emailKey),
                  value: Utils.formatEmptyValue(guardian.email ?? ""),
                ),
                (guardian.mobile ?? "").isEmpty
                    ? const SizedBox()
                    : _buildGuardianDetailsTitleAndValue(
                        context: context,
                        title:
                            Utils.getTranslatedLabel(context, phoneNumberKey),
                        value: Utils.formatEmptyValue(guardian.mobile ?? ""),
                      ),
                (guardian.currentAddress ?? "").isEmpty
                    ? const SizedBox()
                    : _buildGuardianDetailsTitleAndValue(
                        context: context,
                        title: Utils.getTranslatedLabel(context, addressKey),
                        value: Utils.formatEmptyValue(
                            guardian.currentAddress ?? ""),
                      ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
