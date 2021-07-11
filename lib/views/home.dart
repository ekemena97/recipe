import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sundewrecipes/models/recipe_model.dart';
import 'package:sundewrecipes/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  List<RecipeModel> recipes = <RecipeModel>[];
  TextEditingController textEditingController = new TextEditingController();

  getRecipes(String query) async{

    String url = "https://api.edamam.com/search?q=$query&app_id=36633130&app_key=e55b8a9155179503b9eca1758f69119d";

    var response = await http.get(Uri.parse(url));
    Map<String,dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element){
      print(element.toString());

      RecipeModel recipeModel = new RecipeModel(url: "url", source: "source", image: "image", label: "label");
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });

    setState(() {});
    print("${recipes.toString()}");

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                    color: Colors.black87
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: !kIsWeb ? Platform.isIOS ? 80: 40: 40, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Row(
                    mainAxisAlignment: kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Sundew", style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),
                      ),
                      Text("Recipes", style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.w500
                      ),)
                    ],
                  ),
                  SizedBox(height: 30,),
                  Text("What will you love to cook today?", style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Overpass",
                  ),),
                  SizedBox(height: 6,),
                  Text("Just enter an ingredient you have and we will show you the best recipe for you",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      fontFamily: "OverpassRegular",
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget> [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                                hintText: "Enter Ingredients",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.5)
                                )
                            ),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(width: 24,),
                        InkWell(
                          onTap: (){
                            if(textEditingController.text.isNotEmpty){
                              getRecipes(textEditingController.text);
                              print("just do it");
                            }else{
                              print("just don't do it");
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.deepOrangeAccent,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    child: GridView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250, mainAxisSpacing: 5.0
                        ),
                        children: List.generate(recipes.length, (index) {
                          return GridTile(
                              child: RecipeTile(
                                title: recipes[index].label,
                                imgUrl: recipes[index].image,
                                desc: recipes[index].source,
                                url: recipes[index].url,
                              ));
                        })),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({required this.title, required this.desc, required this.imgUrl, required this.url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}