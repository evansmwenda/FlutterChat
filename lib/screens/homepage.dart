import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/tabs/home_tab.dart';
import 'package:flutter_chat/screens/tabs/profile_tab.dart';
import 'package:flutter_chat/screens/tabs/search_tab.dart';
import 'package:flutter_chat/widgets/my_appbar.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/homepage';
  const Homepage({Key key, String uid}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  ///create the pages here
  final HomeTab _homeTab = HomeTab();
  final SearchTab _searchTab = SearchTab();
  final ProfileTab _profileTab = ProfileTab();

  Widget _showPage = HomeTab();

  ///function to switch widgets automatically on page swipe
  Widget _pageChooser(int pageIndex){
    switch(pageIndex){
      case 0:
        return _homeTab;
        break;
      case 1:
        return _searchTab;
        break;
      case 2:
        return _profileTab;
        break;

      default:
        return _homeTab;
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "FlutterChat"),
      body: _showPage,
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _pageIndex,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.home, size: 25,color: Colors.white,),
            Icon(Icons.search, size: 25,color: Colors.white,),
            Icon(Icons.perm_identity, size: 25,color: Colors.white,),
          ],
          color: Colors.blue,
          buttonBackgroundColor: Colors.blue,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              _showPage = _pageChooser(index);
//            print("you have selected index $index");
            });
          },
        )
    );
  }
}
