import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/models/aid_distribution_model.dart';
import 'package:dashboard/provider/aid_distribution_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:dashboard/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddOrEditAidPage extends StatefulWidget {
  final AidDistributionModel? aid;

  const AddOrEditAidPage({super.key, this.aid});

  @override
  State<AddOrEditAidPage> createState() => _AddOrEditAidPageState();
}

class _AddOrEditAidPageState extends State<AddOrEditAidPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _quantityController;
  late TextEditingController _unitController;
  late TextEditingController _distributedByController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late String _email;
  DateTime? _expireDate;
  String _selectedAidType = "Food";

  final List<String> _aidTypes = [
    "Food",
    "Medicine",
    "Cash",
    "Clothing",
    "Shelter",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: widget.aid?.quantity.toString() ?? '');
    _unitController = TextEditingController(text: widget.aid?.unit ?? '');
    _distributedByController =
        TextEditingController(text: widget.aid?.distributedBy ?? '');
    _locationController =
        TextEditingController(text: widget.aid?.location ?? '');
    _notesController = TextEditingController(text: widget.aid?.notes ?? '');
    _expireDate = widget.aid?.expire != null ? widget.aid!.expire! : null;
    _selectedAidType = widget.aid?.aidType ?? "Food";
  }

  void _pickExpireDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expireDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _expireDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    await SharedPreferencesService.getInstance().then((prefs) {
      _email = prefs.getString("email");
    });
    try {
      final aidData = {
        'beneficiaryId': "localhost@mail.com",
        'aidType': _selectedAidType,
        'quantity': int.parse(_quantityController.text.trim()),
        'unit': _unitController.text.trim(),
        'distributedBy': _distributedByController.text.trim(),
        'location': _locationController.text.trim(),
        'notes': _notesController.text.trim(),
        'expire': _expireDate?.toIso8601String(),
      };

      final provider =
          Provider.of<AidDistributionProvider>(context, listen: false);

      if (widget.aid == null) {
        await provider.createAidDistribution(aidData);
      } else {
        await provider.updateAidDistribution(widget.aid!.id!, aidData);
      }
      context.go(AppRoutes.viewAllAids);
    } catch (e) {
      CustomMessage.show(context,
          message: removeExceptionPrefix(e.toString()),
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AidDistributionProvider>(builder: (context, provider, _) {
      return Stack(
        children: [
          Scaffold(
            appBar: CustomAppBar(
                title: widget.aid == null
                    ? "Add Aid Distribution"
                    : "Edit Aid Distribution"),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedAidType,
                        dropdownColor: Colors.white,
                        style: AppTextStyles.poppinsRegularStyle
                            .copyWith(color: AppColors.primary, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: "Aid Type",
                          labelStyle:
                              AppTextStyles.poppinsRegularStyle.copyWith(
                            color: AppColors.light,
                          ),
                          prefixIcon: Icon(Icons.category_outlined,
                              color: AppColors.primary),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.light),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _aidTypes
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAidType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Quantity",
                        hintText: "Enter Quantity",
                        controller: _quantityController,
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Unit",
                        hintText: "e.g. kg, items",
                        controller: _unitController,
                        icon: Icons.straighten,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Distributed By",
                        hintText: "Enter distributor name",
                        controller: _distributedByController,
                        icon: Icons.group_outlined,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Location",
                        hintText: "Enter distribution location",
                        controller: _locationController,
                        icon: Icons.location_on_outlined,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: "Notes",
                        hintText: "Optional notes",
                        controller: _notesController,
                        icon: Icons.notes,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      _buildExpireDatePicker(),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: widget.aid == null
                            ? "Create Aid Record"
                            : "Update Aid Record",
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

  Widget _buildExpireDatePicker() {
    final formatted = _expireDate != null
        ? DateFormat('dd MMM yyyy').format(_expireDate!)
        : "Select Expiry Date";
    return InkWell(
      onTap: _pickExpireDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Expiry Date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatted,
              style: AppTextStyles.poppinsRegularStyle.copyWith(
                  color: _expireDate != null
                      ? AppColors.primary
                      : Colors.grey.shade600),
            ),
            const Icon(Icons.calendar_today, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
