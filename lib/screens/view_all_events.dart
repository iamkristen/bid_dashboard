import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/side_menu.dart';
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
        appBar: CustomAppBar(title: "View All Events"),
        drawer: const SideMenu(),
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

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final start = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(event.startTime));
    final end = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(event.endTime));

    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.transparent, Colors.black],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: Image.network(
                event.banner,
                width: 120,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyles.icebergStyle
                        .copyWith(fontSize: 18, color: AppColors.primary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.poppinsRegularStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "$start - $end",
                          style: AppTextStyles.poppinsRegularStyle
                              .copyWith(fontSize: 12, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTextStyles.poppinsRegularStyle.copyWith(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: AppColors.light,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                            value: event.active ?? false,
                            onChanged: (val) {
                              provider.updateEvent(event.id, {"active": val});
                              provider.updateEventActiveStatus(event.id, val);
                            },
                            activeColor: AppColors.primary,
                            inactiveThumbColor: AppColors.light,
                          ),
                          Text(
                            (event.active ?? false) ? "Active" : "Inactive",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: AppColors.primary),
                            onPressed: () {
                              context.go(
                                  "${AppRoutes.editEventPage}${event.id}",
                                  extra: event);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () {
                              provider.deleteEvent(event.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
