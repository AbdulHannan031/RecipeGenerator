import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedRecipes = prefs.getStringList('saved_recipes');
    List<String>? recipes = prefs.getStringList('recipes');

    final List<Map<String, dynamic>> allRecipes = [];

    if (savedRecipes != null) {
      allRecipes.addAll(savedRecipes.map((recipeString) {
        final decoded = json.decode(recipeString) as Map<String, dynamic>;
        return {
          'title': decoded['title'] as String?,
          'description': decoded['description'] as String?,
        };
      }).toList());
    }

    if (recipes != null) {
      allRecipes.addAll(recipes.map((recipeString) {
        final decoded = json.decode(recipeString) as Map<String, dynamic>;
        return {
          'title': decoded['title'] as String?,
          'description': decoded['description'] as String?,
        };
      }).toList());
    }

    return allRecipes;
  }

  String _truncateDescription(String? description) {
    if (description == null) return '';
    final words = description.split(' ');
    final truncated =
        words.length > 2 ? '${words.take(2).join(' ')}...' : description;
    return truncated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Saved Recipes'),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes available.'));
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      child: Icon(Icons.restaurant_menu, color: Colors.white),
                    ),
                    title: Text(
                      recipe['title'] ?? 'Unknown Title',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.deepOrange),
                    ),
                    subtitle: Text(
                      _truncateDescription(recipe['description']),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            jsonResponse: json.encode(recipe),
                            isSavedRecipe: true,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

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
