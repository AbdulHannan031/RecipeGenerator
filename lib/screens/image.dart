import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageGenerationPage extends StatefulWidget {
  @override
  _ImageGenerationPageState createState() => _ImageGenerationPageState();
}

class _ImageGenerationPageState extends State<ImageGenerationPage> {
  bool _isLoading = false;

  Future<void> _analyzeImage(File imageFile) async {
    final String apiUrl = 'https://aksa.pythonanywhere.com/analyze-recipe';

    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _showResultDialog(responseData); // Show result dialog
      } else {
        _showErrorDialog('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error uploading image. Please try again.');
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File imageFile = File(image.path);
      await _analyzeImage(imageFile);
    }
  }

  Future<void> _showResultDialog(String resultJson) async {
    try {
      // Decode the outer JSON string to get the inner JSON string
      final Map<String, dynamic> outerResult = json.decode(resultJson);
      final String innerJsonString = outerResult['result'] ?? '{}';

      // Decode the inner JSON string to get the recipe data
      final Map<String, dynamic> result = json.decode(innerJsonString);
      final Map<String, dynamic> recipe = result['recipe'];

      // Extract fields from the recipe
      final String title = recipe['title'] ?? 'Unknown Title';
      final String servings = recipe['servings'] ?? 'Unknown Servings';
      final List<dynamic> ingredientsList = recipe['ingredients'] ?? [];
      final String ingredients = ingredientsList.isNotEmpty
          ? ingredientsList.map((i) => i.toString()).join(', ')
          : 'No ingredients available';
      final String description =
          recipe['description']?.replaceAll('\\n', '\n') ??
              'No description available';

      // Show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Recipe Result'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Title: $title',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Servings: $servings'),
                  SizedBox(height: 8),
                  Text('Ingredients:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(ingredients),
                  SizedBox(height: 8),
                  Text('Description:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(description),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Save the result
                  await _saveRecipe(title, servings, ingredients, description);
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Retry logic, if any
                },
                child: Text('Retry'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showErrorDialog('Error parsing recipe result: $e');
    }
  }

  Future<void> _saveRecipe(String title, String servings, String ingredients,
      String description) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String recipeData = json.encode({
      'title': title,
      'servings': servings,
      'ingredients': ingredients,
      'description': description,
    });
    final List<String>? savedRecipes = prefs.getStringList('recipes');
    final List<String> updatedRecipes = savedRecipes ?? [];
    updatedRecipes.add(recipeData);
    await prefs.setStringList('recipes', updatedRecipes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recipe saved successfully!')),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Recipe From Food Image'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepOrange, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Center(
                  child: Icon(
                    Icons.upload,
                    size: 50,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
