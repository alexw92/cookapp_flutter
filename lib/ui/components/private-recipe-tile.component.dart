import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/ui/pages/recipe-details-page.dart';
import 'package:cookable_flutter/ui/pages/recipe-edit-page.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivateRecipeTileComponent extends StatefulWidget {
  PrivateRecipe privateRecipe;
  String apiToken;

  PrivateRecipeTileComponent({Key key, this.privateRecipe, this.apiToken}) : super(key: key);

  @override
  _PrivateRecipeTileComponentState createState() =>
      _PrivateRecipeTileComponentState(privateRecipe: privateRecipe, apiToken: apiToken);
}

class _PrivateRecipeTileComponentState extends State<PrivateRecipeTileComponent> {
  PrivateRecipe privateRecipe;
  String apiToken;

  _PrivateRecipeTileComponentState({this.privateRecipe, this.apiToken});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => navigateToRecipePage(privateRecipe.id),
        child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,

          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(0, 0, 0, 0),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),

          child: Stack(
              fit:StackFit.expand,
              children: [
                Container(
                    height: 300,
                    width: 300,
                    color:Colors.grey,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20), child:Image(
                          // needs --web-renderer html
                          image: CachedNetworkImageProvider(privateRecipe.imgSrc,
                              imageRenderMethodForWeb:
                              ImageRenderMethodForWeb.HttpGet),
                          // backgroundColor: Colors.transparent,
                        ),
                        ))),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(200, 255, 255, 255),
                            border: Border.all(
                              color: Color.fromARGB(0, 0, 0, 0),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Text(this.privateRecipe.name,style: TextStyle(fontSize: 20),textAlign: TextAlign.center))),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 5),
                        child: Row(
                            children:[
                              Chip(
                                labelPadding: EdgeInsets.all(4.0),
                                avatar: Utility.getIconForDiet(privateRecipe.diet),
                                label: Text(
                                  Utility.getTranslatedDiet(context, privateRecipe.diet),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.white,
                                elevation: 6.0,
                                shadowColor: Colors.grey[60],
                                padding: EdgeInsets.all(8.0),
                              ),
                            ])
                    )
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: () => {
                        _openEditRecipeScreen(privateRecipe)
                      }
                      ,
                      child: Icon(Icons.edit),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                        backgroundColor: MaterialStateProperty.all(Colors.white), // <-- Button color,
                      ),
                    )
                    )
              ]),
        )
    );
  }

  navigateToRecipePage(int recipeId) async {
    //navigate to materials page when callbackPath is not report page and list component is clicked
    //Return the result to this component when task is finished from materials
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RecipesDetailsPage(recipeId)));
  }

  Future<void> _openEditRecipeScreen(PrivateRecipe privateRecipe) async {
    print('editRecipeScreen');
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => RecipeEditPage(privateRecipe)));
    print('editRecipeScreen completed');
  }
}
