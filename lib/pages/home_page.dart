import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_visiting_card/pages/form_page.dart';

import '../providers/contact_provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isFirstTime = true;

  @override
  void didChangeDependencies() {
    if (isFirstTime) {
      Provider.of<ContactProvider>(context, listen: false).getAllContacts();
      isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*----- AppBar -----*/
      appBar: AppBar(
        title: const Text("Contact List"),
      ),
      /*----- FloatingActionButton -----*/
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, FormPage.routeName);
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      /*----- BottomNavigationBar -----*/
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        padding: EdgeInsets.zero,
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          backgroundColor: Colors.blueGrey,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'all'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'favorite'),
          ],
        ),
      ),
      /*----- Body -----*/
      body: Consumer<ContactProvider>(builder: (context, contactProvider, child) {
        if (contactProvider.contactList.isEmpty) {
          return const Center(
            child: Text("No Contact Found"),
          );
        } else {
          return ListView.builder(
            itemCount: contactProvider.contactList.length,
            itemBuilder: (context, index) {
              final contact = contactProvider.contactList[index];
              return Card(
                color: Colors.blueGrey,
                margin: const EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.white, size: 40,),
                  title: Text(contact.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),),
                  subtitle: Text(contact.mobile, style: const TextStyle(color: Colors.white, fontSize: 15)),
                  trailing: IconButton(
                    icon: Icon(contact.favorite
                        ? Icons.favorite
                        : Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      //Navigator.pushNamed(context, FormPage.routeName, arguments: contact);
                      contactProvider.updateFavorite(contact);
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
