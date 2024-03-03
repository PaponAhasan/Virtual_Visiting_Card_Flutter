import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/contact.dart';
import '../providers/contact_provider.dart';

class ContactPage extends StatefulWidget {
  static const String routeName = '/contact';

  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int id = 0;
  late Contact contact;

  @override
  void didChangeDependencies() {
    //fetch id from ModalRoute
    id = ModalRoute.of(context)!.settings.arguments as int;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder(
            future: provider.getSingleContacts(id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                contact = snapshot.data!;
                return ListView(children: [
                  Image.asset(
                    contact.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.fitWidth,
                  ),
                  ListTile(
                    title: Text(contact.name),
                  ),
                  ListTile(
                    title: Text(contact.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.sms),
                          onPressed: () {
                            _smsContact(contact.mobile);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () {
                            _callContact(contact.mobile);
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.email.isEmpty
                        ? "not found"
                        : contact.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.email),
                          onPressed: () {
                            _emailContact(contact.email);
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.address.isEmpty
                        ? "not found"
                        : contact.address),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.map),
                          onPressed: () {
                            _openMap(contact.address);
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.website.isEmpty
                        ? "Website not found"
                        : contact.website),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.web),
                          onPressed: () {
                            _openBrowser(contact.website);
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  void _smsContact(String mobile) async {
    final url = 'sms:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _callContact(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _emailContact(String email) async {}

  void _openMap(String address) async {}

  void _openBrowser(String address) async {}
}
