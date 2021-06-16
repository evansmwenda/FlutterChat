import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String  _userName, _emailAddress;
  SharedPreferences _prefs;

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  Future<void> getPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    _userName = await _prefs.getString('fullName') ?? "";
    _emailAddress = await _prefs.getString('emailAddress') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              height: 160,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.blue[700], width: 2.5),
                                  ),
                                  child: IconButton(
                                    onPressed: (){},
                                    icon: Icon(
                                      Icons.perm_identity,
                                      size: 73,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    left: 78,
                                    height: 35,
                                    child: FloatingActionButton(
                                      child: Icon(Icons.camera_alt_outlined),
                                      onPressed: () {
                                        print("clicked change photo");
                                      },
                                    )),
                              ],
                            ),
                            FutureBuilder<SharedPreferences>(
                                future: SharedPreferences.getInstance(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<SharedPreferences> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return null;
                                    case ConnectionState.waiting:
                                      return Container();
                                    case ConnectionState.active:
                                      return Container();
                                    case ConnectionState.done:
                                      return _buildUserData(snapshot.data);
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserData(SharedPreferences data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            // data.getString("fullName") ?? "John Doe",
            "John Doe",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            // data.getString("phoneNumber") ?? "+254712345678",
            "+254712345678",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            // data.getString("emailAddress") ?? "johndoe@gmail.com",
            "johndoe@gmail.com",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
