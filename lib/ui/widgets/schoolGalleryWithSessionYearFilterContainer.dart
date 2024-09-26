import 'package:cached_network_image/cached_network_image.dart';
import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/cubits/schoolGalleryCubit.dart';
import 'package:eschool/cubits/schoolSessionYearsCubit.dart';
import 'package:eschool/data/models/sessionYear.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/ui/widgets/customAppbar.dart';
import 'package:eschool/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SchoolGalleryWithSessionYearFilterContainer extends StatefulWidget {
  final Student student;
  final bool showBackButton;
  const SchoolGalleryWithSessionYearFilterContainer(
      {super.key, required this.student, required this.showBackButton});

  @override
  State<SchoolGalleryWithSessionYearFilterContainer> createState() =>
      _SchoolGalleryWithSessionYearFilterContainerState();
}

class _SchoolGalleryWithSessionYearFilterContainerState
    extends State<SchoolGalleryWithSessionYearFilterContainer> {
  SessionYear selectedSessionYear = SessionYear();
  List<SessionYear> sessionYears = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchSessionYears();
    });
  }

  void fetchSessionYears() {
    context.read<SchoolSessionYearsCubit>().fetchSessionYears(
        useParentApi: context.read<AuthCubit>().isParent(),
        childId: widget.student.id ?? 0);
  }

  void fetchSchoolGallerySessionYearWise() {
    context.read<SchoolGalleryCubit>().fetchSchoolGallery(
        useParentApi: context.read<AuthCubit>().isParent(),
        childId: widget.student.id ?? 0,
        sessionYearId: selectedSessionYear.id ?? 0);
  }

  Widget _buildSessionYearDropDown() {
    final sessionYearNameTextStyle =
        TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.primary);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Utils.screenContentHorizontalPadding),
      alignment: AlignmentDirectional.centerStart,
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.32)),
      child: BlocConsumer<SchoolSessionYearsCubit, SchoolSessionYearsState>(
          listener: (context, state) {
        if (state is SchoolSessionYearsFetchSuccess) {
          sessionYears = state.sessionYears;
          selectedSessionYear =
              sessionYears.firstWhere((element) => element.isDefault == 1);
          setState(() {});
          fetchSchoolGallerySessionYearWise();
        }
        //
      }, builder: (context, state) {
        if (state is SchoolSessionYearsFetchSuccess) {
          return DropdownButton<SessionYear>(
              iconEnabledColor: Theme.of(context).colorScheme.primary,
              isExpanded: true,
              value: selectedSessionYear,
              items: sessionYears
                  .map((sessionYear) => DropdownMenuItem<SessionYear>(
                      value: sessionYear,
                      child: Text(
                        sessionYear.name ?? "",
                        style: sessionYearNameTextStyle,
                      )))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedSessionYear = value;
                  setState(() {});
                  fetchSchoolGallerySessionYearWise();
                }
              });
        }

        if (state is SchoolSessionYearsFetchFailure) {
          return Row(
            children: [
              Text(
                Utils.getTranslatedLabel(context, failedToGetSessionYearsKey),
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    fetchSessionYears();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          );
        }
        return Text(
          Utils.getTranslatedLabel(context, fetchingSessionYearsKey),
          style: sessionYearNameTextStyle,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: 25,
              left: Utils.screenContentHorizontalPadding,
              right: Utils.screenContentHorizontalPadding,
              top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarSmallerHeightPercentage)),
          child: Column(
            children: [
              _buildSessionYearDropDown(),
              const SizedBox(
                height: 25,
              ),
              BlocBuilder<SchoolGalleryCubit, SchoolGalleryState>(
                builder: (context, state) {
                  if (state is SchoolGalleryFetchSuccess) {
                    return Column(
                      children: state.gallery.map((gallery) {
                        final photosAndVideosCountTextStyle = TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.65));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    Routes.galleryDetails,
                                    arguments: {
                                      "gallery": gallery,
                                      "sessionYear": selectedSessionYear
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 175,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Utils.bottomSheetTopRadius),
                                  child: gallery.isThumbnailSvg()
                                      ? SvgPicture.network(
                                          gallery.thumbnail ?? "",
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: gallery.thumbnail ?? "",
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, top: 15),
                              child: Text(
                                (gallery.title ?? ""),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.0,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                gallery.getImages().isNotEmpty
                                    ? Text(
                                        "${gallery.getImages().length} ${Utils.getTranslatedLabel(context, photosKey)}",
                                        style: photosAndVideosCountTextStyle,
                                      )
                                    : const SizedBox(),
                                gallery.getVideos().isNotEmpty &&
                                        gallery.getImages().isNotEmpty
                                    ? Text(
                                        " | ",
                                        style: photosAndVideosCountTextStyle,
                                      )
                                    : const SizedBox(),
                                gallery.getVideos().isNotEmpty
                                    ? Text(
                                        "${gallery.getVideos().length} ${Utils.getTranslatedLabel(context, videosKey)}",
                                        style: photosAndVideosCountTextStyle,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                  if (state is SchoolGalleryFetchFailure) {
                    return Center(
                      child: ErrorContainer(
                        errorMessageCode: state.errorMessage,
                        onTapRetry: () {
                          fetchSchoolGallerySessionYearWise();
                        },
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * (0.3)),
                    child: Center(
                      child: CustomCircularProgressIndicator(
                        indicatorColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: galleryKey,
              showBackButton: widget.showBackButton,
            )),
      ],
    );
  }
}
