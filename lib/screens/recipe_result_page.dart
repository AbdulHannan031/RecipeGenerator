import 'package:flutter/material.dart';
import 'dart:convert';

class RecipeDetailPage extends StatelessWidget {
  final String jsonResponse;
  final bool isSavedRecipe;

  RecipeDetailPage({required this.jsonResponse, required this.isSavedRecipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Detail'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _parseRecipe(jsonResponse, isSavedRecipe),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No recipe details available.'));
          } else {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Placeholder for recipe image

                  SizedBox(height: 20),
                  Text(
                    recipe['title'] ?? 'Unknown Title',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    recipe['description'] ?? 'No description available',
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _parseRecipe(
      String jsonResponse, bool isSavedRecipe) async {
    try {
      if (isSavedRecipe) {
        final decoded = json.decode(jsonResponse) as Map<String, dynamic>;
        return {
          'title': decoded['title'] as String?,
          'description': decoded['description'] as String?,
        };
      } else {
        final outerResult = json.decode(jsonResponse) as Map<String, dynamic>;
        final innerJsonString = outerResult['result'] ?? '{}';
        final result = json.decode(innerJsonString) as Map<String, dynamic>;
        final recipe = result['recipe'] as Map<String, dynamic>;

        return {
          'title': recipe['title'] as String?,
          'description': recipe['description'] as String?,
        };
      }
    } catch (e) {
      throw Exception('Error parsing recipe data: $e');
    }
  }
}
