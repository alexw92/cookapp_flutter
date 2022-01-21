class NeedsRecipeUpdateState {
  static final NeedsRecipeUpdateState _singleton = NeedsRecipeUpdateState._internal();
  bool recipesUpdateNeeded = true;

  factory NeedsRecipeUpdateState() {
    return _singleton;
  }

  NeedsRecipeUpdateState._internal();
}