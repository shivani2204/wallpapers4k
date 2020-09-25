import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../providers/models/girls.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url =
      "https://api.pexels.com/v1/search?query=girls&per_page=80&page=1";
  String m = '';
  Girls girlsWalls;
  Photo photourl;
  bool isLoading = false;

  get assets => null;
  //Girls userapi;
  fetchapi() async {
    setState(() {
      isLoading = true;
    });
    var res = await http.get(url, headers: {
      "Authorization":
          "563492ad6f917000010000011caaf6716a94499792b5de8e53ab375d"
    });
    var decoded = jsonDecode(res.body);

    girlsWalls = Girls.fromJson(decoded);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchapi();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var center = Center(
      child: CircularProgressIndicator(),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: isLoading
            ? center
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(
                  girlsWalls.photos.length,
                  (index) {
                    var boxFit = BoxFit.fill;

                    var container = Container(
                        child: InkWell(
                            onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  var cover = BoxFit.cover;
                                  return Image(
                                    image: NetworkImage(
                                        girlsWalls.photos[index].src.portrait),
                                    fit: cover,
                                  );
                                })),
                            child: Hero(
                              tag: girlsWalls.photos[index].src.portrait,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  image: NetworkImage(
                                      girlsWalls.photos[index].src.portrait),
                                  fit: boxFit,
                                ),
                              ),
                            )));
                    return container;
                  },
                ),
              ));
  }
}
