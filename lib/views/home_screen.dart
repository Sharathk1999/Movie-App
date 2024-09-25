import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];
 

  List screens = [
    HomeScreen(),
    SearchScreen(),
  ];
  

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Movies',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.red,))
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index]['show'];
                return ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag:   movie['image'] != null ? movie['image']['medium'] : '',
                        child: Image.network(
                          movie['image'] != null ? movie['image']['medium'] : '',
                          fit: BoxFit.cover,
                        
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset("assets/images/Movie-App-Logo.png"),
                        ),
                      ),
                    ),
                  ),
                  title: Text(movie['name'],maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,),),
                  subtitle: Text(movie['summary'] != null
                      ? movie['summary'].replaceAll(RegExp('<[^>]*>'), '')
                      : '',maxLines: 3,overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.white,),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(movie: movie)),
                    );
                  },
                );
              },
            ),
   
    );
  }
}
