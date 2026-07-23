import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/model/category.dart';
import 'package:app_web/model/subcategory.dart';
import 'package:flutter/material.dart';

class SubcategoryWidget extends StatefulWidget {
  const SubcategoryWidget({super.key});

  @override
  State<SubcategoryWidget> createState() => _SubcategoryWidgetState();
}

class _SubcategoryWidgetState extends State<SubcategoryWidget> {
  late Future<List<SubCategoryModel>>futureCategories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = SubcategoryController().loadSubcategories();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: futureCategories, builder: (context,snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Hass Error ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Sub Categories'));
          } else {
            final subcategories = snapshot.data!;
            return GridView.builder(
              shrinkWrap: true,
                itemCount: subcategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemBuilder: (context, index) {
                  final subcategory = subcategories[index];
                  return Column(
                    children: [
                      Image.network(
                          subcategory.image,
                          width: 100,
                          height: 100,
                        ),
                        Text(subcategory.subCategoryName),
                    ],
                  );
                }
            );
          }
    });
  }
}