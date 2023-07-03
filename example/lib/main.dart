import 'package:flutter/material.dart';
import 'package:nautilus/nautilus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final router = NautilusNav(
    routes: [
      NavRoute(
        path: '/',
        handler: (context, state) => HomePage(),
      ),
      NavRoute(
        path: '/detail',
        handler: (context, state) {
          final book = state.params['book'] as Book?;

          return BookDetailsScreen(
            book: book!,
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Material App',
      routeInformationParser: router.parser,
      routerDelegate: router.delegate,
      // home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  final List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () {
                NautilusNav.of(context).nav(
                  '/detail',
                  params: {'book': book},
                );
              },
            )
        ],
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title),
            Text(book.author),
          ],
        ),
      ),
    );
  }
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}
