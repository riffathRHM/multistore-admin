import 'dart:typed_data';
import 'package:app_web/views/side_bar_screens/widgets/category_widget.dart';
import 'package:app_web/controllers/category_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = '\category-screen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  late String name;
  Uint8List? _image;
  Uint8List? _bannerImage;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }
  Future<void> pickBannerImage() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: _image != null
                          ? Image.memory(_image!)
                          : Text('Category Image'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter category name';
                        }
                      },
                      decoration:
                          InputDecoration(labelText: 'Enter Category Name'),
                    ),
                  ),
                ),
                TextButton(onPressed: () {}, child: Text('Cancel')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                      await _categoryController.uploadCategory(pickedImage: _image, pickedBanner: _bannerImage, name:name , context: context);
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 6, 6, 6),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    pickImage();
                  },
                  child: Text(
                    'Pick Image',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: _bannerImage != null
                      ? Image.memory(_bannerImage!)
                      : Text('Category Banner',style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 6, 6, 6),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    pickBannerImage();
                  },
                  child: const Text(
                    'Pick Image',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
           const Padding(
              padding: EdgeInsets.all(4.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
