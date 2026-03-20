import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserEditScreen extends StatefulWidget {
  final UserModel user;
  const UserEditScreen({super.key, required this.user});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _firstnameCtrl;
  late final TextEditingController _lastnameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _numberCtrl;
  late final TextEditingController _zipcodeCtrl;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _firstnameCtrl = TextEditingController(text: u.name.firstname);
    _lastnameCtrl = TextEditingController(text: u.name.lastname);
    _emailCtrl = TextEditingController(text: u.email);
    _usernameCtrl = TextEditingController(text: u.username);
    _phoneCtrl = TextEditingController(text: u.phone);
    _cityCtrl = TextEditingController(text: u.address.city);
    _streetCtrl = TextEditingController(text: u.address.street);
    _numberCtrl = TextEditingController(text: u.address.number.toString());
    _zipcodeCtrl = TextEditingController(text: u.address.zipcode);
  }

  @override
  void dispose() {
    _firstnameCtrl.dispose();
    _lastnameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _streetCtrl.dispose();
    _numberCtrl.dispose();
    _zipcodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final body = {
      'email': _emailCtrl.text.trim(),
      'username': _usernameCtrl.text.trim(),
      'password': widget.user.password,
      'name': {
        'firstname': _firstnameCtrl.text.trim(),
        'lastname': _lastnameCtrl.text.trim(),
      },
      'address': {
        'city': _cityCtrl.text.trim(),
        'street': _streetCtrl.text.trim(),
        'number': int.tryParse(_numberCtrl.text.trim()) ?? widget.user.address.number,
        'zipcode': _zipcodeCtrl.text.trim(),
      },
      'phone': _phoneCtrl.text.trim(),
    };

    final success = await context.read<UserProvider>().updateUser(widget.user.id, body);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกข้อมูลสำเร็จ'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาด ไม่สามารถบันทึกได้'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล User #${widget.user.id}'),
        backgroundColor: Colors.orange,
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                )
              : IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'บันทึก',
                  onPressed: _save,
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader('ข้อมูลส่วนตัว'),
            Row(
              children: [
                Expanded(child: _buildField('ชื่อ (Firstname)', _firstnameCtrl)),
                const SizedBox(width: 12),
                Expanded(child: _buildField('นามสกุล (Lastname)', _lastnameCtrl)),
              ],
            ),
            _buildField('Email', _emailCtrl, keyboardType: TextInputType.emailAddress),
            _buildField('Username', _usernameCtrl),
            _buildField('เบอร์โทร', _phoneCtrl, keyboardType: TextInputType.phone),
            const SizedBox(height: 8),
            _sectionHeader('ที่อยู่'),
            _buildField('เมือง (City)', _cityCtrl),
            _buildField('ถนน (Street)', _streetCtrl),
            _buildField('บ้านเลขที่ (Number)', _numberCtrl, keyboardType: TextInputType.number),
            _buildField('รหัสไปรษณีย์ (Zipcode)', _zipcodeCtrl),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isSaving ? null : _save,
                icon: const Icon(Icons.save),
                label: const Text('บันทึกข้อมูล', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        validator: (value) => (value == null || value.trim().isEmpty) ? 'กรุณากรอก $label' : null,
      ),
    );
  }
}
