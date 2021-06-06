import 'package:flutter/material.dart';

class ThemeProvider extends StatefulWidget {
  final ThemeData initialTheme;
  final MaterialApp Function(BuildContext context, ThemeData theme)
      materialAppBuilder;

  const ThemeProvider({Key key, this.initialTheme, this.materialAppBuilder})
      : super(key: key);

  @override
  _ThemeProviderState createState() => _ThemeProviderState();

  static void setTheme(BuildContext context, ThemeData theme) {
    var state = context.findAncestorStateOfType<_ThemeProviderState>();
    state.theme = theme;
  }
}

class _ThemeProviderState extends State<ThemeProvider> {
  ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = widget.initialTheme;
  }

  @override
  Widget build(BuildContext context) {
    return widget.materialAppBuilder(context, theme);
  }
}
