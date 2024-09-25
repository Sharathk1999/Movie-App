import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/views/details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  TextEditingController searchController = TextEditingController();

// Function to search movies as user types
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        forceMaterialTransparency: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: searchController,
          cursorColor: Colors.white,
          
          style: const TextStyle(color: Colors.white),
          decoration:  InputDecoration(
            hintText: 'Search movies...',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)
              
              
            ),
            
          ),
          onChanged: (query) {
            searchMovies(query);
          },
        ),
      ),
      body: searchResults.isEmpty
          ? const Center(
              child: Text(
              'Search for a movies 🔍',
              style: TextStyle(color: Colors.white),
            ))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final movie = searchResults[index]['show'];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(movie: movie)),
                    );
                  },
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        movie['image'] != null ? movie['image']['medium'] : '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset("assets/images/Movie-App-Logo.png"),
                      ),
                    ),
                  ),
                  title: Text(
                    movie['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    movie['summary'] != null
                        ? movie['summary'].replaceAll(RegExp('<[^>]*>'), '')
                        : '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
    );
  }
}
