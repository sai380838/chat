import 'package:chat/auth_bloc.dart';
import 'package:chat/country_model.dart';
import 'package:chat/country_service.dart';
import 'package:chat/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confCtrl = TextEditingController();
  String? selectedCountry;
  //List<String> countries = [];
  List<Country> _countries = [];
  Country? _selectedCountry;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  // Future<void> _loadCountries() async {
  //   countries = await CountryService().fetchCountries();
  //   setState(() {});
  // }
  Future<void> loadCountries() async {
    try {
      List<Country> countries = await CountryService().fetchCountriess();
      setState(() {
        _countries = countries;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      debugPrint("Failed to load countries: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('signup').tr()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: 'email'.tr()),
            ),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: 'display_name'.tr()),
            ),
            TextField(
              controller: mobileCtrl,
              decoration: InputDecoration(labelText: 'mobile'.tr()),
            ),

            // DropdownButtonFormField<String>(
            //   value: selectedCountry,
            //   items: countries
            //       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            //       .toList(),
            //   onChanged: (val) => setState(() => selectedCountry = val),
            //   decoration: InputDecoration(labelText: 'country'.tr()),
            // ),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<Country>(
                    value: _selectedCountry,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select a country' : null,
                    items: _countries.map((country) {
                      return DropdownMenuItem<Country>(
                        value: country,
                        child: Row(
                          children: [
                            Image.network(
                              country.flagUrl,
                              width: 24,
                              height: 16,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Text(country.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCountry = value);
                      // if (widget.onChanged != null && value != null) {
                      //   widget.onChanged!(value);
                      // }
                    },
                  ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: 'password'.tr()),
            ),
            TextField(
              controller: confCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: 'confirm_password'.tr()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final token =
                    await FirebaseMessaging.instance.getToken() ?? "dummy";
                final user = UserModel(
                  email: emailCtrl.text,
                  displayName: nameCtrl.text,
                  mobile: mobileCtrl.text,
                  country: _selectedCountry!.name ?? '',
                  token: token,
                );
                context.read<AuthBloc>().add(
                  RegisterSubmitted(user, confCtrl.text),
                );
              },
              child: Text('signup').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
