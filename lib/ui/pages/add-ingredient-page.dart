import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:cookable_flutter/core/data/models.dart';
import 'package:cookable_flutter/core/io/controllers.dart';
import 'package:cookable_flutter/core/io/token-store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddIngredientPage extends StatefulWidget {
  AddIngredientPage({Key key}) : super(key: key);

  @override
  _AddIngredientPageState createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  String searchString = "";
  Future<List<FoodProduct>> foodProducts;
  String apiToken;

  _AddIngredientPageState();

  void initState() {
    super.initState();
    loadToken();
    foodProducts = FoodProductController.getFoodProducts();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).addIngredient)),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).searchIngredient,
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                builder: (context, AsyncSnapshot<List<FoodProduct>> snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                        child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return snapshot.data[index].name
                                .toLowerCase()
                                .contains(searchString)
                            ? ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      "${snapshot.data[index].imgSrc}",
                                      headers: {
                                        "Authorization": "Bearer $apiToken",
                                        "Access-Control-Allow-Headers":
                                        "Access-Control-Allow-Origin, Accept"
                                      },
                                      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet),
                                  radius: 30,
                                ),
                                title: Text('${snapshot.data[index].name}'),
                                subtitle: Text(
                                    'Placeholder: ${snapshot.data[index].name}'),
                              )
                            : Container();
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return snapshot.data[index].name
                                .toLowerCase()
                                .contains(searchString)
                            ? Divider()
                            : Container();
                      },
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong :('));
                  }
                  return Center(child: CircularProgressIndicator());
                },
                future: foodProducts,
                // Our existing list code
              ),
            ),
          ],
        ));
  }

   void loadToken() async {
    apiToken = await TokenStore().getToken();
  }

}
