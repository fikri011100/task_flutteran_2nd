import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:task_flutteran_2nd/CustomAppBar.dart';
import 'package:task_flutteran_2nd/CustomShapeClipper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:task_flutteran_2nd/model/DataJson.dart';

void main() => runApp(MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: appTheme,
    ));

Color firstColor = Color(0xFFF47015);
Color secondColor = Color(0xFFEF772C);

String url =
    'https://api.themoviedb.org/3/movie/upcoming?api_key=4b30bbd498e2942ffe2941c58bc3d42d&language=en-US&page=1';
// String url = 'https://newsapi.org/v2/everything?q=anime&from=2019-05-27&sortBy=publishedAt&apiKey=77ba78b1e80b4916a22c01755966e9b9';

List data;
var extractdata;

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFFF3791A),
  fontFamily: 'Oxygen',
);

List<String> location = ['Boston (BOS)', 'New York (JFK)'];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      extractdata = jsonDecode(response.body);
      data = extractdata["results"];
    });

    print(response.body);
  }

  @override
  void initState() {
    makeRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HomeScreenTopPart(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: homeScreenBottomPart,
            ),
            Container(
              height: 340.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, i) {
                  return ListCard(
                    data[i]["id"].toString(),
                    "https://image.tmdb.org/t/p/w500" + data[i]["poster_path"],
                    data[i]["title"],
                    data[i]["original_title"],
                    data[i]["vote_average"].toString(),
                    data[i]["popularity"].toString(),
                    data[i]["release_date"].toString(),
                    i,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

const TextStyle dropDownLabelStyle =
    TextStyle(color: Colors.white, fontSize: 16.0);
const TextStyle dropDownMenuItemStyle =
    TextStyle(color: Colors.black, fontSize: 16.0);
var viewAllStyle = TextStyle(fontSize: 14.0, color: appTheme.primaryColor);

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  var selectedLocationIndex = 0;
  var isFlightSelected = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 400.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [firstColor, secondColor])),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      PopupMenuButton(
                        onSelected: (index) {
                          setState(() {
                            selectedLocationIndex = index;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              location[0],
                              style: dropDownLabelStyle,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            )
                          ],
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<int>>[
                              PopupMenuItem(
                                child: Text(
                                  location[0],
                                  style: dropDownMenuItemStyle,
                                ),
                                value: 0,
                              ),
                              PopupMenuItem(
                                child: Text(
                                  location[1],
                                  style: dropDownMenuItemStyle,
                                ),
                                value: 1,
                              )
                            ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'What would\nyou want to watch?',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    child: TextField(
                      style: dropDownMenuItemStyle,
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                          hintText: 'Search Here',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 14.0),
                          suffixIcon: Material(
                            elevation: 2.0,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      child: ChoiceChip(
                          Icons.calendar_today, 'Upcoming', isFlightSelected),
                      onTap: () {
                        setState(() {
                          isFlightSelected = true;
                        });
                      },
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    InkWell(
                      child: ChoiceChip(
                          Icons.star, 'Top Rated', !isFlightSelected),
                      onTap: () {
                        setState(() {
                          isFlightSelected = false;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ChoiceChip extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  const ChoiceChip(this.icon, this.text, this.isSelected);

  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(Radius.circular(20.0)))
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20.0,
            color: Colors.white,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            widget.text,
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          )
        ],
      ),
    );
  }
}

var homeScreenBottomPart = Column(
  children: <Widget>[
    Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Currently Watched Items',
          style: dropDownMenuItemStyle,
        ),
        Spacer(),
        Text(
          'VIEW ALL(2)',
          style: viewAllStyle,
        ),
      ],
    ),
  ],
);

// List<ListCard> listCard = [
//   ListCard('1233453', 'assets/images/member3.jpg', 'Oppaniv', 'Jul 2019', '8.9',
//       'lontey'),
//   ListCard('2893649', 'assets/images/member4.jpg', 'Stanley', 'May 2019',
//       '10.0', 'lontod'),
//   ListCard('1029473', 'assets/images/member5.jpg', 'Tubagood', 'Jan 2019',
//       '7.5', 'lonfag'),
// ];

class ListCard extends StatelessWidget {
  final String id,
      imagePath,
      titleName,
      realName,
      popularity,
      releaseDate,
      voteAverage;
  final int newIndex;

  ListCard(this.id, this.imagePath, this.realName, this.titleName,
      this.voteAverage, this.popularity, this.releaseDate, this.newIndex);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DetailResponse(data[newIndex])));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 300,
                    width: 200,
                    child: Image.network(
                      imagePath == null
                          ? 'https://i1.wp.com/www.ecommerce-nation.com/wp-content/uploads/2018/10/404-error.jpg'
                          : imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 200.0,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black,
                            Colors.black12.withOpacity(0.1)
                          ])),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(realName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18.0)),
                              Text(titleName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontSize: 14.0)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text(voteAverage,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black)),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     SizedBox(
            //       width: 5.0,
            //     ),
            //     Text(releaseDate,
            //         style: TextStyle(
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18.0)),
            //     SizedBox(
            //       width: 5.0,
            //     ),
            //     Text(popularity,
            //         style: TextStyle(
            //             color: Colors.grey,
            //             fontWeight: FontWeight.normal,
            //             fontSize: 14.0)),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

class DetailResponse extends StatelessWidget {
  final data;

  DetailResponse(this.data);

  @override
  Widget build(BuildContext context) {
    final String newUrl =
        "https://api.themoviedb.org/3/movie/${data['id'].toString()}?api_key=4b30bbd498e2942ffe2941c58bc3d42d&language=en-US";

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 500,
                      width: 500,
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w500" +
                                    data["backdrop_path"] ==
                                null
                            ? 'https://i1.wp.com/www.ecommerce-nation.com/wp-content/uploads/2018/10/404-error.jpg'
                            : "https://image.tmdb.org/t/p/w500" +
                                data["backdrop_path"],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      width: 500,
                      height: 450.0,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.0)
                            ])),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 250,
                                  width: 150,
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500" +
                                                data["poster_path"] ==
                                            null
                                        ? 'https://i1.wp.com/www.ecommerce-nation.com/wp-content/uploads/2018/10/404-error.jpg'
                                        : "https://image.tmdb.org/t/p/w500" +
                                            data["poster_path"],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: Text(data["title"],
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 28.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(data["release_date"] + " | ",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                        fontSize: 14.0)),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Text(data["vote_average"].toString(),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[700])),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Material(
                              elevation: 2.0,
                              color: appTheme.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                DetailBodyResponse(newUrl),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 10.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailBodyResponse extends StatefulWidget {
  final String bodyUrl;

  DetailBodyResponse(this.bodyUrl);

  _DetailBodyResponseState createState() => _DetailBodyResponseState();
}

class _DetailBodyResponseState extends State<DetailBodyResponse> {
  var extractdatabody;

  Future<String> makeRequestBody() async {
    var response = await http.get(Uri.encodeFull(widget.bodyUrl),
        headers: {"Accept": "application/json"});

    setState(() {
      extractdatabody = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    makeRequestBody();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Text(
                "Overview",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(extractdatabody["overview"]),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Text(
                "Release date",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(extractdatabody["release_date"]),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Text(
                "Runtime",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(extractdatabody["runtime"].toString() + " minutes"),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Text(
                "Genres",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(extractdatabody["genres"].toString() + " minutes"),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Text(
                "Production companies",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(extractdatabody["production_companies"][0]["name"]),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Text(
                "Production countries",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(extractdatabody["production_countries"][0]["name"] +
                ", etc"),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
              child: Text(
                "Belongs to Collection",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(extractdatabody["belongs_to_collection"].toString()),
          ],
        ),
      ),
    );
  }
}