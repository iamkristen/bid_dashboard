import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dashboard/provider/event_provider.dart';
import 'package:dashboard/models/event_models.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/components/custom_appbar.dart';

class ViewEventByIdPage extends StatefulWidget {
  final String eventId;

  const ViewEventByIdPage({super.key, required this.eventId});

  @override
  State<ViewEventByIdPage> createState() => _ViewEventByIdPageState();
}

class _ViewEventByIdPageState extends State<ViewEventByIdPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false)
          .fetchEventById(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final EventModel? event = eventProvider.selectedEvent;

    return Scaffold(
      appBar: CustomAppBar(title: "Event Details"),
      body: eventProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventProvider.error != null
              ? Center(
                  child: Text(
                  eventProvider.error!,
                  style: AppTextStyles.poppinsRegularStyle,
                ))
              : event == null
                  ? const Center(child: Text("Event not found"))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.network(
                                  event.banner,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: AppTextStyles.icebergStyle
                                          .copyWith(
                                              fontSize: 24,
                                              color: AppColors.primary),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      event.description,
                                      style: AppTextStyles.poppinsRegularStyle
                                          .copyWith(
                                              fontSize: 14,
                                              color: AppColors.primary),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Start: ${_formatDateTime(event.startTime)}",
                                          style: AppTextStyles
                                              .poppinsRegularStyle
                                              .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_outlined),
                                        const SizedBox(width: 8),
                                        Text(
                                          "End: ${_formatDateTime(event.endTime)}",
                                          style: AppTextStyles
                                              .poppinsRegularStyle
                                              .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        const SizedBox(width: 8),
                                        Text(
                                          event.location,
                                          style: AppTextStyles
                                              .poppinsRegularStyle
                                              .copyWith(
                                                  fontSize: 14,
                                                  color: AppColors.primary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline),
                                        const SizedBox(width: 8),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                  text: "Status: ",
                                                  style: AppTextStyles
                                                      .poppinsRegularStyle
                                                      .copyWith(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .primary)),
                                              TextSpan(
                                                text: event.active == true
                                                    ? "Active"
                                                    : "Inactive",
                                                style: AppTextStyles
                                                    .poppinsRegularStyle
                                                    .copyWith(
                                                  fontSize: 14,
                                                  color: event.active == true
                                                      ? Colors.green
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ],
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
                      ),
                    ),
    );
  }

  String _formatDateTime(String isoString) {
    final dateTime = DateTime.parse(isoString);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }
}
