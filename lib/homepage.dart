import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_pagination/bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieListBloc movieListBloc;
 
  ScrollController controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    movieListBloc = MovieListBloc();
    movieListBloc.fetchFirstList();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase firestore pagination"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: movieListBloc.movieStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                  child: Text(snapshot.data[index]["rank"].toString())),
                              title: Text(snapshot.data[index]["title"]),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: StreamBuilder(
                stream: movieListBloc.getShowIndicatorStream,
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data == true) {
                    return const CircularProgressIndicator();
                  }
                  return const ListTile();
                },
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      movieListBloc.fetchNextMovies();
    }
  }
}
