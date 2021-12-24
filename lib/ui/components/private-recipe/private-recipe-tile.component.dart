import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private-recipe-details-page.dart';
import 'package:cookable_flutter/ui/pages/private-recipe/private-recipe-edit-page.dart';
import 'package:cookable_flutter/ui/util/fb_storage_utils.dart';
import 'package:cookable_flutter/ui/util/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class PrivateRecipeTileComponent extends StatefulWidget {
  PrivateRecipe privateRecipe;
  String apiToken;

  PrivateRecipeTileComponent({Key key, this.privateRecipe, this.apiToken})
      : super(key: key);

  @override
  _PrivateRecipeTileComponentState createState() =>
      _PrivateRecipeTileComponentState(
          privateRecipe: privateRecipe, apiToken: apiToken);
}

class _PrivateRecipeTileComponentState
    extends State<PrivateRecipeTileComponent> {
  PrivateRecipe privateRecipe;
  String apiToken;
  String recipeImgUrl;
  bool defaultImg = false;
  final picker = ImagePicker();

  _PrivateRecipeTileComponentState({this.privateRecipe, this.apiToken});

  @override
  void initState() {
    getImageUrl();
    super.initState();
  }

  getImageUrl() async {
    print(privateRecipe.imgSrc);
    if (privateRecipe.imgSrc.contains("food.png")) {
      setState(() {
        defaultImg = true;
      });
      return;
    }
    var imgUrl = await FBStorage.getPrivateRecipeImgDownloadUrl(privateRecipe.imgSrc);
    setState(() {
      defaultImg = false;
      recipeImgUrl = imgUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!defaultImg && recipeImgUrl == null) return Container();
    return GestureDetector(
        onTap: () => navigatePrivateToRecipePage(privateRecipe.id),
        child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          height: 300,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(0, 0, 0, 0),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Stack(fit: StackFit.expand, children: [
            Container(
                height: 300,
                width: 300,
                color: Colors.grey,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        // needs --web-renderer html
                        image: CachedNetworkImageProvider(
                            (defaultImg) ? privateRecipe.imgSrc : recipeImgUrl,
                            //privateRecipe.imgSrc,
                            imageRenderMethodForWeb:
                                ImageRenderMethodForWeb.HttpGet),
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
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(this.privateRecipe.name,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center))),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 5),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(spacing: 3, children: [
                          Chip(
                            labelPadding: EdgeInsets.all(4.0),
                            avatar: Utility.getIconForDiet(privateRecipe.diet),
                            label: Text(
                              Utility.getTranslatedDiet(
                                  context, privateRecipe.diet),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: EdgeInsets.all(8.0),
                          ),
                          getHighProteinChipIfNeeded(),
                          getHighCarbChipIfNeeded()
                        ])))),
            Positioned(
                top: 36,
                right: 0,
                child: Column(children: [
                  ElevatedButton(
                    onPressed: () => {_editPrivateRecipeImg(privateRecipe)},
                    child: Icon(Icons.camera_alt),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white), // <-- Button color,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {_openEditRecipeScreen(privateRecipe)},
                    child: Icon(Icons.edit),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white), // <-- Button color,
                    ),
                  )
                ]))
          ]),
        ));
  }

  navigatePrivateToRecipePage(int recipeId) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PrivateRecipeDetailsPage(recipeId)));
  }

  Future<void> _openEditRecipeScreen(PrivateRecipe privateRecipe) async {
    print('editRecipeScreen');
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeEditPage(privateRecipe.id)));
    print('editRecipeScreen completed');
  }

  _editPrivateRecipeImg(PrivateRecipe privateRecipe) async {
    var image = await pickImage();
    RecipeController.updatePrivateRecipeImage(privateRecipe, image);
  }

  Future<File> pickImage({bool fromGallery = true}) async {
    final pickedFile = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    return File(pickedFile.path);
  }

  Widget getHighProteinChipIfNeeded() {
    return (privateRecipe.nutrients.isHighProteinRecipe)
        ? Chip(
            labelPadding: EdgeInsets.all(4.0),
            avatar: Icon(
              Icons.fitness_center,
            ),
            label: Text(
              AppLocalizations.of(context).highProtein,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.all(8.0),
          )
        : Container();
  }

  Widget getHighCarbChipIfNeeded() {
    return (privateRecipe.nutrients.isHighCarbRecipe)
        ? Chip(
            labelPadding: EdgeInsets.all(4.0),
            avatar: Icon(
              Icons.directions_bike,
            ),
            label: Text(
              AppLocalizations.of(context).highCarb,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.all(8.0),
          )
        : Container();
  }
}
