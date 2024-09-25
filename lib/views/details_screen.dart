import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          movie['name'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              movie['image'] != null && movie['image']['medium'] != null && movie['image']['medium'].isNotEmpty
                  ? SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag:   movie['image']['medium'],
                        child: Image.network(
                            movie['image']['medium'],
                            scale: 1.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset("assets/images/Movie-App-Logo.png"), 
                          ),
                      ),
                    ),
                  )
                  : Image.asset("assets/images/Movie-App-Logo.png"), 
              const SizedBox(height: 10),
              Text(
                movie['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                movie['summary'] != null
                    ? movie['summary'].replaceAll(RegExp('<[^>]*>'), '')
                    : 'No summary available',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
