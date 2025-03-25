import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/models/event_models.dart';
import 'package:dashboard/provider/event_provider.dart';
import 'package:dashboard/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart' as quill_delta;

class AddOrEditEventPage extends StatefulWidget {
  final EventModel? event;

  const AddOrEditEventPage({super.key, this.event});

  @override
  State<AddOrEditEventPage> createState() => _AddOrEditEventPageState();
}

class _AddOrEditEventPageState extends State<AddOrEditEventPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late quill.QuillController _descriptionController;
  late String? _email;

  DateTime? _startTime;
  DateTime? _endTime;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _locationController =
        TextEditingController(text: widget.event?.location ?? '');

    _descriptionController = widget.event != null
        ? quill.QuillController(
            document: quill.Document.fromDelta(
              quill_delta.Delta()..insert('${widget.event!.description}\n'),
            ),
            selection: const TextSelection.collapsed(offset: 0),
          )
        : quill.QuillController.basic();

    _startTime =
        widget.event != null ? DateTime.parse(widget.event!.startTime) : null;
    _endTime =
        widget.event != null ? DateTime.parse(widget.event!.endTime) : null;
    _isActive = widget.event?.active ?? true;
  }

  Future<void> _pickDateTime(bool isStart) async {
    final initialDate =
        isStart ? _startTime ?? DateTime.now() : _endTime ?? DateTime.now();

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
        setState(() {
          if (isStart) {
            _startTime = fullDateTime;
          } else {
            _endTime = fullDateTime;
          }
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() != true ||
        _startTime == null ||
        _endTime == null) {
      return;
    }
    await SharedPreferencesService.getInstance().then((prefs) {
      _email = prefs.getString("email");
    });

    final descriptionText =
        _descriptionController.document.toPlainText().trim();

    final eventData = {
      'title': _titleController.text.trim(),
      'description': descriptionText,
      'location': _locationController.text.trim(),
      'startTime': _startTime!.toIso8601String(),
      'endTime': _endTime!.toIso8601String(),
      'active': _isActive,
      'hostID': _email,
    };
    try {
      final provider = Provider.of<EventProvider>(context, listen: false);
      if (widget.event == null) {
        print(eventData);
        await provider.createEvent(eventData);
      } else {
        provider.updateEvent(widget.event!.id, eventData);
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
                        controller: _titleController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Description",
                          style: AppTextStyles.poppinsRegularStyle
                              .copyWith(fontSize: 14, color: AppColors.primary),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.light),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 250,
                        child: Column(
                          children: [
                            QuillSimpleToolbar(
                              controller: _descriptionController,
                              config: const QuillSimpleToolbarConfig(
                                showAlignmentButtons: false,
                                showColorButton: false,
                                showDirection: false,
                                showBackgroundColorButton: false,
                                showListCheck: true,
                                showQuote: true,
                                showHeaderStyle: true,
                                color: AppColors.primary,
                                iconTheme: QuillIconTheme(
                                  iconButtonUnselectedData:
                                      IconButtonData(color: AppColors.light),
                                  iconButtonSelectedData:
                                      IconButtonData(color: AppColors.primary),
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                            const SizedBox(height: 4),
                            Expanded(
                              child: quill.QuillEditor.basic(
                                controller: _descriptionController,
                                config: const QuillEditorConfig(
                                  padding: EdgeInsets.all(8),
                                  placeholder: 'Enter description here',
                                  expands: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomTextField(
                        label: "Location",
                        hintText: "Enter location",
                        icon: Icons.location_on,
                        controller: _locationController,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(
                          "Start Time", _startTime, () => _pickDateTime(true)),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(
                          "End Time", _endTime, () => _pickDateTime(false)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Active Status",
                              style: TextStyle(fontSize: 16)),
                          Switch(
                            value: _isActive,
                            onChanged: (val) => setState(() => _isActive = val),
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
                        onPressed: _submitForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (provider.isLoading) AppLoader(),
        ],
      );
    });
  }

  Widget _buildDateTimePicker(
      String label, DateTime? value, VoidCallback onTap) {
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
