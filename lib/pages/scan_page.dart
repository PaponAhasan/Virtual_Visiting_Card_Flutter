import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_visiting_card/models/contact.dart';

import '../utils/constants.dart';
import 'form_page.dart';

class ScanPage extends StatefulWidget {
  static const String routeName = '/scan';

  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanOver = false;
  List<String> lines = [];
  String name = '',
      mobile = '',
      email = '',
      address = '',
      company = '',
      website = '',
      designation = '',
      image = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code"), actions: [
        TextButton(
          onPressed: image.isEmpty ? null : _createContactModelFromScanValues,
          child: const Text("Next"),
        )
      ]),
      body: ListView(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton.icon(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              icon: const Icon(Icons.camera),
              label: const Text("Capture"),
            ),
            TextButton.icon(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo_album),
              label: const Text("Gallery"),
            ),
          ]),
          if (isScanOver)
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  DropTargetItem(
                      property: ContactProperties.name,
                      onDrop: _getPropertyValue),
                  DropTargetItem(
                      property: ContactProperties.designation,
                      onDrop: _getPropertyValue),
                  DropTargetItem(
                      property: ContactProperties.company,
                      onDrop: _getPropertyValue),
                  DropTargetItem(
                      property: ContactProperties.address,
                      onDrop: _getPropertyValue),
                  DropTargetItem(
                      property: ContactProperties.email,
                      onDrop: _getPropertyValue),
                  DropTargetItem(
                      property: ContactProperties.mobile,
                      onDrop: _getPropertyValue),
                  DropTargetItem(
                      property: ContactProperties.website,
                      onDrop: _getPropertyValue),
                ]),
              ),
            ),
          if (isScanOver)
            const Padding(
                padding: EdgeInsets.all(8.0), child: Text(dragInstruction)),
          Wrap(
            children: lines.map((line) => LineItem(line: line)).toList(),
          )
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final xFile = await ImagePicker().pickImage(source: source);

    if (xFile != null) {
      _showDefaultLoading();

      image = xFile.path;
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognisedText =
          await textRecognizer.processImage(InputImage.fromFile(File(image)));
      final tempLines = <String>[];
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          tempLines.add(line.text);
        }
      }
      setState(() {
        lines = tempLines;
        isScanOver = true;
        _showSuccess();
      });
    }
  }

  _getPropertyValue(String property, String value) {
    switch (property) {
      case ContactProperties.name:
        name = value;
        break;
      case ContactProperties.designation:
        designation = value;
        break;
      case ContactProperties.company:
        company = value;
        break;
      case ContactProperties.address:
        address = value;
        break;
      case ContactProperties.email:
        email = value;
        break;
      case ContactProperties.mobile:
        mobile = value;
        break;
      case ContactProperties.website:
        website = value;
        break;
      default:
        break;
    }
  }

  void _createContactModelFromScanValues() {
    final contact = Contact(
        name: name,
        designation: designation,
        company: company,
        address: address,
        email: email,
        mobile: mobile,
        website: website,
        image: image
    );
    Navigator.pushNamed(context, FormPage.routeName, arguments: contact);
  }
}

class LineItem extends StatelessWidget {
  final String line;

  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final GlobalKey globalKey = GlobalKey();
    return LongPressDraggable(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
      feedback: Container(
          key: globalKey,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(
            line,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          )),
      child: Chip(
        label: Text(line),
      ),
    );
  }
}

class DropTargetItem extends StatefulWidget {
  final String property;
  final Function(String, String) onDrop;

  const DropTargetItem(
      {super.key, required this.property, required this.onDrop});

  @override
  State<DropTargetItem> createState() => _DropTargetItemState();
}

class _DropTargetItemState extends State<DropTargetItem> {
  String draggedItem = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(widget.property)),
        Expanded(
          flex: 2,
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: candidateData.isNotEmpty
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: Row(children: [
                Expanded(
                    child:
                        Text(draggedItem.isEmpty ? 'Drop here' : draggedItem)),
                if (draggedItem.isNotEmpty)
                  InkWell(
                      onTap: () {
                        setState(() {
                          draggedItem = '';
                        });
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: 15,
                      )),
              ]),
            ),
            onAccept: (value) {
              setState(() {
                if (draggedItem.isEmpty) {
                  draggedItem = value;
                } else {
                  draggedItem += ' $value';
                }
              });
              widget.onDrop(widget.property, draggedItem);
            },
          ),
        )
      ],
    );
  }
}

// Show default loading with a status message
void _showDefaultLoading() {
  EasyLoading.show(status: 'Loading...');
}

void _showSuccess() {
  EasyLoading.showSuccess('Loaded successfully!');
  EasyLoading.dismiss();
}
