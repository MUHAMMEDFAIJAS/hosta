import 'package:flutter/material.dart';
import 'package:hosta/controller/donor_controllor.dart';
import 'package:hosta/model/blood_bank_model.dart';
import 'package:hosta/service/blood_bank_service.dart';
import 'package:provider/provider.dart';

class AddBloodDonor extends StatefulWidget {
  const AddBloodDonor({super.key});

  @override
  State<AddBloodDonor> createState() => _AddBloodDonorState();
}

class _AddBloodDonorState extends State<AddBloodDonor> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _donationDateController = TextEditingController();

  String? _selectedBloodGroup;
  final List<String> _bloodGroups = [
    "O+",
    "O-",
    "AB+",
    "AB-",
    "A+",
    "A-",
    "B+",
    "B-"
  ];
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Blood Donor'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_nameController, 'Name',
                    validator: _requiredValidator),
                _buildTextField(_emailController, 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator),
                _buildTextField(_phoneController, 'Phone',
                    keyboardType: TextInputType.phone,
                    validator: _phoneValidator),
                _buildTextField(_ageController, 'Age',
                    keyboardType: TextInputType.number,
                    validator: _ageValidator),
                _buildDropdown(),
                _buildTextField(_placeController, 'Place',
                    validator: _requiredValidator),
                _buildTextField(_pincodeController, 'Pincode',
                    keyboardType: TextInputType.number,
                    validator: _pincodeValidator),
                _buildDatePickerField(),
                const SizedBox(height: 20),
                _isSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _donationDateController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Last Donation Date',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.year}-${_pad(pickedDate.month)}-${_pad(pickedDate.day)}";
            setState(() {
              _donationDateController.text = formattedDate;
            });
          }
        },
        validator: _requiredValidator,
      ),
    );
  }

  String _pad(int number) => number.toString().padLeft(2, '0');

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedBloodGroup,
        items: _bloodGroups
            .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
            .toList(),
        onChanged: (value) => setState(() => _selectedBloodGroup = value),
        decoration: const InputDecoration(
          labelText: 'Blood Group',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null ? 'Select a blood group' : null,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBloodGroup == null) return;

    setState(() => _isSubmitting = true);

    try {
      final provider = Provider.of<BloodDonorProvider>(context, listen: false);

      // Create new donor object
      final newDonor = BloodDonor(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        age: int.parse(_ageController.text),
        bloodGroup: _selectedBloodGroup!,
        address: Address(
          place: _placeController.text.trim(),
          pincode: int.parse(_pincodeController.text),
        ),
        lastDonationDate: DateTime.parse(_donationDateController.text.trim()),
      );

     
      await provider.addDonor(newDonor);

    
      await BloodDonorService.createDonor(
        name: newDonor.name,
        email: newDonor.email,
        phone: newDonor.phone,
        age: newDonor.age,
        bloodGroup: newDonor.bloodGroup,
        place: newDonor.address.place,
        pincode: newDonor.address.pincode,
        lastDonationDate: _donationDateController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donor added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add donor: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _requiredValidator(String? value) =>
      (value == null || value.isEmpty) ? 'This field is required' : null;

  String? _emailValidator(String? value) =>
      (value == null || !value.contains('@')) ? 'Enter a valid email' : null;

  String? _phoneValidator(String? value) =>
      (value == null || value.length != 10)
          ? 'Enter a 10-digit phone number'
          : null;

  String? _pincodeValidator(String? value) =>
      (value == null || value.length != 6) ? 'Enter a 6-digit pincode' : null;

  String? _ageValidator(String? value) {
    if (value == null || value.isEmpty) return 'Age is required';
    final age = int.tryParse(value);
    return (age == null || age < 18) ? 'Age must be at least 18' : null;
  }
}
