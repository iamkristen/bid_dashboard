import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/models/event_models.dart';
import 'package:dashboard/provider/event_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserEventsPage extends StatefulWidget {
  const UserEventsPage({super.key});

  @override
  State<UserEventsPage> createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: CustomAppBar(title: "Events"),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.light,
                      labelStyle: AppTextStyles.poppinsRegularStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      dividerColor: Colors.transparent,
                      onTap: (index) {
                        final provider =
                            Provider.of<EventProvider>(context, listen: false);
                        if (index == 0) {
                          provider.setFilter("All");
                        } else if (index == 1) {
                          provider.setFilter("Upcoming");
                        } else if (index == 2) {
                          provider.setFilter("Active");
                        } else if (index == 3) {
                          provider.setFilter("Inactive");
                        } else if (index == 4) {
                          provider.setFilter("Expired");
                        } else {
                          provider.setFilter("All");
                        }
                      },
                      tabs: const [
                        Tab(text: "All"),
                        Tab(text: "Upcoming"),
                        Tab(text: "Active"),
                        Tab(text: "Inactive"),
                        Tab(text: "Expired"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: "Add Event",
                    icon: Icons.add,
                    onPressed: () {
                      context.go(AppRoutes.addEventPage);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, _) {
                  if (eventProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (eventProvider.error != null) {
                    return Center(child: Text(eventProvider.error!));
                  } else if (eventProvider.filteredEvents.isEmpty) {
                    return Center(
                        child: Text(
                      "No events found",
                      style: AppTextStyles.poppinsRegularStyle
                          .copyWith(color: Colors.white, fontSize: 16),
                    ));
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: eventProvider.filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = eventProvider.filteredEvents[index];
                        return GestureDetector(
                          onTap: () => context
                              .go("${AppRoutes.eventByIdPage}${event.id}"),
                          child: EventCard(event: event),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.event.active ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final event = widget.event;
    final start = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(event.startTime));
    final end = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(event.endTime));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  if (event.banner.isNotEmpty)
                    Positioned.fill(
                      // right: 200,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Image.network(
                              event.banner,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12)),
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          event.title,
                          style: AppTextStyles.icebergStyle
                              .copyWith(fontSize: 20, color: AppColors.primary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          event.description,
                          style: AppTextStyles.poppinsRegularStyle.copyWith(
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "$start - $end",
                                style: AppTextStyles.poppinsRegularStyle
                                    .copyWith(
                                        fontSize: 12, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                event.location,
                                style: AppTextStyles.poppinsRegularStyle
                                    .copyWith(
                                        fontSize: 12, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              color: AppColors.light,
              thickness: 1,
              width: 32,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: isActive,
                    onChanged: (val) {
                      setState(() {
                        isActive = val;
                      });
                      provider.updateEvent(widget.event.id, {"active": val});
                    },
                    activeColor: AppColors.primary,
                    inactiveThumbColor: AppColors.light,
                  ),
                  Text(
                    isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              color: AppColors.light,
              thickness: 1,
              width: 32,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: "Edit",
                      width: double.infinity,
                      onPressed: () {
                        context.go("${AppRoutes.editEventPage}${event.id}",
                            extra: event);
                      },
                      icon: Icons.edit,
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: "Delete",
                      width: double.infinity,
                      onPressed: () {
                        final provider =
                            Provider.of<EventProvider>(context, listen: false);
                        provider.deleteEvent(event.id);
                      },
                      icon: Icons.delete_outline,
                      backgroundColor: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
