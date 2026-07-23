import 'dart:typed_data';

import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/model/category.dart';
import 'package:app_web/views/side_bar_screens/widgets/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = '\sub-category-screen';
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  late Future<List<Category>> futureCategories;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final SubcategoryController _subcategoryController = SubcategoryController();
  late String name;
  Uint8List? _image;
  Category? selectedCategory;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Subcategories',
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
            FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Hass error ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Category'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<Category>(
                        value: selectedCategory,
                        hint: const Text("Select Category"),
                        items: snapshot.data!.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                      
                          print(selectedCategory?.name);
                        },
                      ),
                    );
                  }
                }),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: _image != null
                          ? Image.memory(_image!)
                          : Text('SubCategory Image'),
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
                          return 'Please enter subcategory name';
                        }
                      },
                      decoration: InputDecoration(labelText: 'Enter SubCategory Name'),
                    ),
                  ),
                ),
                
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                      await  _subcategoryController.uploadSubcategory(categoryId: selectedCategory!.id, categoryName: selectedCategory!.name, pickedImage: _image, subCategoryName: name, context: context);
        
                      setState((){
                        _formkey.currentState!.reset();
                        _image = null;
                      });
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
                Divider(color: Colors.grey,),
        
                SubcategoryWidget(),
          ],
        ),
      ),
    );
  }
}
