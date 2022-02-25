import 'package:cookable_flutter/core/caching/like_service.dart';
import 'package:cookable_flutter/core/caching/private_recipe_service.dart';
import 'package:cookable_flutter/core/caching/recipe_service.dart';
import 'package:cookable_flutter/core/caching/user_service.dart';
import 'package:cookable_flutter/core/caching/userfood_service.dart';
import 'package:cookable_flutter/ui/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signOut(BuildContext context) async {
  print('signout');
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  // clear user specific data
  clearUserSpecificData();

  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

Future<void> clearUserSpecificData() async {
  // clear user specific data
  var userFoodService = UserFoodService();
  var recipeService = RecipeService();
  var privateService = PrivateRecipeService();
  var userService = UserService();
  var likeService = LikeService();
  await userFoodService.clearUserFood();
  await recipeService.clearRecipes();
  await privateService.clearPrivateRecipes();
  await userService.clearUsers();
  await likeService.clearUserRecipeLikes();
}

