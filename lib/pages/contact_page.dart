import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:virtual_visiting_card/utils/helpers.dart';

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
                  Image.file(
                    File(contact.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.fitWidth,
                  ),
                  // Image.asset(
                  //   contact.image,
                  //   width: double.infinity,
                  //   height: 250,
                  //   fit: BoxFit.fitWidth,
                  // ),
                  ListTile(
                    title: Text(contact.name),
                  ),
                  ListTile(
                    title: Text(contact.mobile),
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
                    title: Text(
                        contact.email.isEmpty ? "not found" : contact.email),
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
      showMessage(context, "can't send message");
      throw 'Could not launch $url';
    }
  }

  void _callContact(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMessage(context, "can't call");
      throw 'Could not launch $url';
    }
  }

  void _emailContact(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': "subject",
        'body': "body",
      },
    );
    final String url = emailUri.toString();
    //final String url ='mailto:$email';
    //final String url ='mailto:$email?subject=subject&body=body';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMessage(context, "can't send email");
      throw 'Could not launch $url';
    }
  }

  void _openMap(String address) async {
    //final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
      //url = 'geo:0,0?q=${Uri.encodeComponent(address)}';
    } else if (Platform.isIOS) {
      //url = 'https://maps.apple.com/?q=$address';
      url = 'https://maps.apple.com/?q=${Uri.encodeComponent(address)}';
    }

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMessage(context, "can't open map");
      throw 'Could not launch $url';
    }
  }

  void _openBrowser(String website) async {
    final url = website;
    //final url = 'https://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMessage(context, "can't open browser");
      throw 'Could not launch $url';
    }
  }
}
