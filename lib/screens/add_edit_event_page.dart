import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/models/event_models.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddOrEditEventPage extends StatefulWidget {
  final EventModel? event;

  const AddOrEditEventPage({super.key, this.event});

  @override
  State<AddOrEditEventPage> createState() => _AddOrEditEventPageState();
}

class _AddOrEditEventPageState extends State<AddOrEditEventPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.resetFormData(event: widget.event);
    });
  }

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final initialDate = isStart
        ? provider.startTime ?? DateTime.now()
        : provider.endTime ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (time != null) {
        final fullDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        if (isStart) {
          provider.startTime = fullDateTime;
        } else {
          provider.endTime = fullDateTime;
        }
        provider.notifyListeners();
      }
    }
  }

  void _submitForm(
    BuildContext context,
  ) async {
    final provider = Provider.of<EventProvider>(context, listen: false);

    if (_formKey.currentState?.validate() != true ||
        provider.startTime == null ||
        provider.endTime == null) {
      return;
    }

    try {
      if (widget.event == null) {
        await provider.createEventFromState();
      } else {
        await provider.updateEvent(widget.event!.id, {
          'title': provider.titleController.text.trim(),
          'description': provider.descriptionController.text.trim(),
          'location': provider.locationController.text.trim(),
          'startTime': provider.startTime!.toIso8601String(),
          'endTime': provider.endTime!.toIso8601String(),
          'active': provider.isActive,
        });
      }

      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/eventsPage');
      }
    } catch (e) {
      CustomMessage.show(context,
          message: removeExceptionPrefix(e.toString()),
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(builder: (context, provider, child) {
      return Stack(
        children: [
          Scaffold(
            appBar: CustomAppBar(
              title: widget.event == null ? "Add Event" : "Edit Event",
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: provider.pickImage,
                          child: Container(
                            width: 300,
                            height: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.light),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(4, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: provider.bannerbytes != null
                                ? Image.memory(
                                    provider.bannerbytes!,
                                    width: 180,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 50,
                                    color: AppColors.primary,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Title",
                        hintText: "Enter event title",
                        icon: Icons.title,
                        controller: provider.titleController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Description",
                        hintText: "Enter event title",
                        icon: Icons.description,
                        controller: provider.descriptionController,
                        maxLines: 6,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Location",
                        hintText: "Enter location",
                        icon: Icons.location_on,
                        controller: provider.locationController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(
                          context,
                          "Start Time",
                          provider.startTime,
                          () => _pickDateTime(context, true)),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(
                          context,
                          "End Time",
                          provider.endTime,
                          () => _pickDateTime(context, false)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Active Status",
                              style: TextStyle(fontSize: 16)),
                          Switch(
                            value: provider.isActive,
                            onChanged: (val) {
                              provider.isActive = val;
                              provider.notifyListeners();
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: widget.event == null
                            ? "Create Event"
                            : "Update Event",
                        icon: Icons.save,
                        onPressed: () => _submitForm(
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (provider.isLoading) const AppLoader(),
        ],
      );
    });
  }

  Widget _buildDateTimePicker(
      BuildContext context, String label, DateTime? value, VoidCallback onTap) {
    final formatted = value != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(value)
        : "Select $label";
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.poppinsRegularStyle.copyWith(
            color: AppColors.light,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.light),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatted,
              style: AppTextStyles.poppinsRegularStyle.copyWith(
                color: value != null ? AppColors.primary : Colors.grey,
              ),
            ),
            const Icon(Icons.calendar_today,
                size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
