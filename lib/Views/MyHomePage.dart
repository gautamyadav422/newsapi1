import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:newsapi1/Views/category.dart';
import 'package:newsapi1/Views/newview.dart';
import 'package:newsapi1/models/model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchEditingController = TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];

  List<String> navBarItem = ["Top News", "World", "India", "Health", "finance"];
  bool isLoading = true;

  getNewsByQuery({required String query}) async {
    Map news;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2021-08-10&sortBy=publishedAt&apiKey=bc622e9315024f019bf243b165460890";
    var response = await http.get(
      Uri.parse(url),
    );
    Map data = jsonDecode(response.body);

    setState(() {
      for (news in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(news);
          newsModelList.add(newsQueryModel);

          setState(() {
            isLoading = false;
          });
          if (i == 5) {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  getNewsByQueryHeader() async {
    Map news;
    int i = 0;
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=bc622e9315024f019bf243b165460890";
    var response = await http.get(
      Uri.parse(url),
    );
    Map data = jsonDecode(response.body);

    setState(() {
      for (news in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(news);
          newsModelListCarousel.add(newsQueryModel);

          setState(() {
            isLoading = false;
          });
          if (i == 5) {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(query: "india");
    getNewsByQueryHeader();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Flutter"),
              Text(
                "News",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((searchEditingController.text)
                                  .replaceAll("", "") ==
                              "") {
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                  Query: searchEditingController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchEditingController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            if (value == "") {
                              print("Balnk search");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                    Query: value,
                                  ),
                                ),
                              );
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Search "),
                        ),
                      )
                    ],
                  ),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: navBarItem.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryPage(
                                              Query: navBarItem[index],
                                            )));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(navBarItem[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: isLoading
                      ? Container(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()))
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                          items: newsModelListCarousel.map((instance) {
                            return Builder(builder: (BuildContext context) {
                              try {
                                return Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewsView(instance.newUrl)));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              instance.newsImg,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black12
                                                            .withOpacity(0),
                                                        Colors.black
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter)),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    instance.newsHead,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print(e);
                                return Container();
                              }
                            });
                          }).toList(),
                        ),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "LATEST NEWS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: newsModelList.length,
                              itemBuilder: (context, index) {
                                try {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NewsView(
                                                newsModelList[index].newUrl),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                newsModelList[index].newsImg,
                                                fit: BoxFit.fitHeight,
                                                width: double.infinity,
                                                height: 300,
                                              ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                  height: 140,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black12
                                                              .withOpacity(0),
                                                          Colors.black
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 15, 10, 4),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        newsModelList[index]
                                                            .newsHead,
                                                        //         .newsHead
                                                        //         .length >
                                                        //     50
                                                        // ? "${newsModelList[index].newsHead.substring(0, 75)}."
                                                        // : newsModelList[index]
                                                        //     .newsHead,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        newsModelList[index]
                                                                    .newsDes
                                                                    .length >
                                                                50
                                                            ? "${newsModelList[index].newsDes.substring(0, 55)}..."
                                                            : newsModelList[
                                                                    index]
                                                                .newsDes,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print(e);
                                  return Container();
                                }
                              },
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryPage(
                                                    Query: "Technology",
                                                  )));
                                    },
                                    child: Text("Show More"),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
