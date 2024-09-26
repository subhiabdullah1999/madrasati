import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/noticeBoardCubit.dart';
import 'package:eschool/cubits/schoolConfigurationCubit.dart';
import 'package:eschool/cubits/schoolGalleryCubit.dart';
import 'package:eschool/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/data/repositories/schoolRepository.dart';
import 'package:eschool/ui/widgets/borderedProfilePictureContainer.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/customShimmerContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/latestNoticesContainer.dart';
import 'package:eschool/ui/widgets/schoolGalleryContainer.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoaders/announcementShimmerLoadingContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoaders/subjectsShimmerLoadingContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool/ui/widgets/slidersContainer.dart';
import 'package:eschool/ui/widgets/studentSubjectsContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/systemModules.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Student student;
  const ChildDetailsScreen({Key? key, required this.student}) : super(key: key);

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => SchoolGalleryCubit(SchoolRepository()),
        child: ChildDetailsScreen(
          student: routeSettings.arguments as Student,
        ),
      ),
    );
  }
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchChildSchoolDetails();
    });
    super.initState();
  }

  void fetchChildSchoolDetails() {
    context.read<SchoolConfigurationCubit>().fetchSchoolConfiguration(
        useParentApi: true, childId: widget.student.id ?? 0);
  }

  void fetchChildSubjectAndSliders() {
    context.read<StudentSubjectsAndSlidersCubit>().fetchSubjectsAndSliders(
        isSliderModuleEnable: Utils.isModuleEnabled(
            context: context, moduleId: sliderManagementModuleId.toString()),
        useParentApi: true,
        childId: widget.student.id ?? 0);
  }

  void fetchNoticeBoardDetails() {
    if (Utils.isModuleEnabled(
        context: context,
        moduleId: announcementManagementModuleId.toString())) {
      context.read<NoticeBoardCubit>().fetchNoticeBoardDetails(
          useParentApi: true, childId: widget.student.id);
    }
  }

  void fetchGalleryDetails() {
    if (Utils.isModuleEnabled(
        context: context, moduleId: galleryManagementModuleId.toString())) {
      context.read<SchoolGalleryCubit>().fetchSchoolGallery(
          useParentApi: true,
          childId: widget.student.id,
          sessionYearId: context
                  .read<SchoolConfigurationCubit>()
                  .getSchoolConfiguration()
                  .sessionYear
                  .id ??
              0);
    }
  }

  void schoolConfigurationCubitListener(
      BuildContext context, SchoolConfigurationState state) {
    if (state is SchoolConfigurationFetchSuccess) {
      fetchChildSubjectAndSliders();
      fetchNoticeBoardDetails();
      fetchGalleryDetails();
    }
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: ScreenTopBackgroundContainer(
        padding: EdgeInsets.zero,
        heightPercentage: Utils.appBarBiggerHeightPercentage,
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Stack(
              children: [
                //Bordered circles
                PositionedDirectional(
                  top: MediaQuery.of(context).size.width * (-0.15),
                  start: MediaQuery.of(context).size.width * (-0.225),
                  child: Container(
                    padding: const EdgeInsetsDirectional.only(
                      end: 20.0,
                      bottom: 20.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.1),
                      ),
                      shape: BoxShape.circle,
                    ),
                    width: MediaQuery.of(context).size.width * (0.6),
                    height: MediaQuery.of(context).size.width * (0.6),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.1),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                //bottom fill circle
                PositionedDirectional(
                  bottom: MediaQuery.of(context).size.width * (-0.15),
                  end: MediaQuery.of(context).size.width * (-0.15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    width: MediaQuery.of(context).size.width * (0.4),
                    height: MediaQuery.of(context).size.width * (0.4),
                  ),
                ),
                CustomBackButton(
                  topPadding: MediaQuery.of(context).padding.top +
                      Utils.appBarContentTopPadding,
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top +
                          Utils.appBarContentTopPadding,
                      left: 10,
                      right: 10.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BorderedProfilePictureContainer(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.studentProfile,
                              arguments: widget.student.id,
                            );
                          },
                          heightAndWidth: boxConstraints.maxWidth * (0.16),
                          imageUrl:
                              widget.student.childUserDetails?.image ?? "",
                        ),
                        SizedBox(
                          height: boxConstraints.maxHeight * (0.045),
                        ),
                        Text(
                          widget.student.getFullName(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: boxConstraints.maxHeight * (0.0125),
                        ),
                        Text(
                          "${Utils.getTranslatedLabel(context, classKey)} - ${widget.student.classSection?.fullName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                BlocBuilder<StudentSubjectsAndSlidersCubit,
                    StudentSubjectsAndSlidersState>(
                  builder: (context, state) {
                    if (state is StudentSubjectsAndSlidersFetchSuccess) {
                      return Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: IconButton(
                          color: Theme.of(context).colorScheme.surface,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top +
                                Utils.appBarContentTopPadding,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              Routes.parentMenu,
                              arguments: {
                                "student": widget.student,
                                "subjectsForFilter": context
                                    .read<StudentSubjectsAndSlidersCubit>()
                                    .getSubjectsForAssignmentContainer()
                              },
                            );
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDataLoadingContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * (0.075),
            ),
            width: MediaQuery.of(context).size.width,
            borderRadius: 25,
            height: MediaQuery.of(context).size.height *
                Utils.appBarBiggerHeightPercentage,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        const SubjectsShimmerLoadingContainer(),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * (0.075),
          ),
          child: Column(
            children: List.generate(2, (index) => index)
                .map(
                  (e) => const AnnouncementShimmerLoadingContainer(),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _buildSubjectsAndInformationsContainer() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
            ) -
            60,
      ),
      child: BlocBuilder<StudentSubjectsAndSlidersCubit,
          StudentSubjectsAndSlidersState>(
        builder: (context, state) {
          if (state is StudentSubjectsAndSlidersFetchSuccess) {
            return Column(
              children: [
                SlidersContainer(sliders: state.sliders),
                StudentSubjectsContainer(
                  subjects: context
                      .read<StudentSubjectsAndSlidersCubit>()
                      .getSubjects(),
                  subjectsTitleKey: subjectsKey,
                  childId: widget.student.id,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                Utils.isModuleEnabled(
                        context: context,
                        moduleId: announcementManagementModuleId.toString())
                    ? LatestNoticiesContainer(
                        childId: widget.student.id,
                      )
                    : const SizedBox(),
                Utils.isModuleEnabled(
                        context: context,
                        moduleId: galleryManagementModuleId.toString())
                    ? SchoolGalleryContainer(
                        student: widget.student,
                      )
                    : const SizedBox(),
              ],
            );
          }
          if (state is StudentSubjectsAndSlidersFetchFailure) {
            return Center(
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: () {
                  fetchChildSubjectAndSliders();
                },
              ),
            );
          }
          return _buildDataLoadingContainer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<SchoolConfigurationCubit, SchoolConfigurationState>(
              listener: schoolConfigurationCubitListener,
              builder: (context, state) {
                if (state is SchoolConfigurationFetchSuccess) {
                  return _buildSubjectsAndInformationsContainer();
                }
                if (state is SchoolConfigurationFetchFailure) {
                  return Center(
                    child: ErrorContainer(
                      errorMessageCode: state.errorMessage,
                      onTapRetry: () {
                        fetchChildSchoolDetails();
                      },
                    ),
                  );
                }

                return _buildDataLoadingContainer();
              }),
          _buildAppBar(),
        ],
      ),
    );
  }
}
