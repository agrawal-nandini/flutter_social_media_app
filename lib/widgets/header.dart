import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar header(context,
    {String title = "",
    bool isApptitle = false,
    bool removeBackBotton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackBotton ? false : true,
    title: Text(
      title,
      style: isApptitle
          ? GoogleFonts.dancingScript(
              color: Colors.white,
              fontSize: 42,
            )
          : GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
            ),
    ),
    centerTitle: true,
    // toolbarHeight: isApptitle ? 70 : 60,
    backgroundColor: Theme.of(context).accentColor,
    // leadingWidth: 60,
  );
}
