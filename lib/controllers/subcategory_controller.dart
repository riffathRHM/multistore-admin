
import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/model/subcategory.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  uploadSubcategory({required String categoryId,required String categoryName,required dynamic pickedImage,required String subCategoryName,required context})async {
    try {
       final cloudinary = CloudinaryPublic(
        "drox3zlt0",
        'jijppjse',
      );

      // upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'categoryImages',
        ),
      );

      String image = imageResponse.secureUrl;
      SubCategoryModel subcategory = SubCategoryModel(id: '', categoryId: categoryId, categoryName: categoryName, image: image, subCategoryName: subCategoryName);
      
       http.Response response = await http.post(
        Uri.parse("$uri/api/subcategories"),
        body: subcategory.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Uploaded SubCategory');
        },
      );
      
    } catch(e){
      print('$e');
    }
  }

  Future<List<SubCategoryModel>> loadSubcategories() async {
    try {
       final response = await http.get(Uri.parse('$uri/api/subcategories'),headers: <String,String>{
         "Content-Type":'application/json;charset=UTF-8'
       },);
       print(response.body);
       if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        List<SubCategoryModel> subcategories = data.map((subcategory)=>SubCategoryModel.fromJson(subcategory)).toList();
        return subcategories;
       } else {
        throw Exception('Failed to load subCategories');
       }
    }catch(e){
       print('$e');
        throw Exception('Error loading SubCategories:$e');
    }
  }
}