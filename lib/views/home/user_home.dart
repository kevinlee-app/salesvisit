import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/menu.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/auth.dart';
import 'package:salesvisit/shared/constants.dart';
import 'package:salesvisit/shared/dashboard_menu_row.dart';
import 'package:salesvisit/shared/label_below_icon.dart';
import 'package:salesvisit/views/scanner/scanner.dart';
import 'package:salesvisit/views/store/store_menu.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Size deviceSize;
  UserData user;
  final AuthService _authService = AuthService();

  Widget appBarColumn(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
          child: new Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: 50),
                  Expanded(
                      child: Text(
                    'Welcome ' + user.name + " !",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  )),
                  PopupMenuButton(
                    onSelected: (String type) => _onPopupItemSelected(type),
                    icon: Icon(
                      Icons.more_vert,
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: "sign_out",
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Sign Out"),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  dateText(),
                ],
              )
            ],
          ),
        ),
      );

  Widget actionMenuCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DashboardMenuRow(
                    listMenu: [
                      LabelBelowIcon(
                        icon: Icons.store,
                        label: "Stores",
                        circleColor: Colors.blue,
                        onPressed: () => _goToMenu(MenuType.stores),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget userVisitTotalList(BuildContext context) => Container(
        height: 110,
        child: ListView.separated(
          itemCount: 5,
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: 10),
          itemBuilder: (context, index) {
            return userVisitTotalTile();
          },
        ),
      );

  Widget userVisitDetailsList(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return userVisitDetailsTile();
          },
        ),
      );

  Widget dashboardBottom(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 22),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                    )
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      height: deviceSize.height * 0.04,
                      child: Text(
                        'VISITS',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    userVisitDetailsList(context)
                  ]),
            ),
          ],
        ),
      );

  Widget userVisitDetailsTile() => ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text('Three-line ListTile'),
        subtitle: Text('A sufficiently long subtitle warrants three lines.'),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
      );

  Widget userVisitTotalTile() => Container(
        width: deviceSize.width * 0.55,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '20 Visit',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Subtitle Subtitle Subtitle',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget background() => Container(
        height: deviceSize.height * 0.385,
        decoration:
            BoxDecoration(gradient: LinearGradient(colors: kitGradients)),
      );

  Widget dateText() => Text(
        '17 May 2020',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );

  Widget allCards(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            appBarColumn(context),
            SizedBox(height: deviceSize.height * 0.002),
            actionMenuCard(),
            SizedBox(height: deviceSize.height * 0.04),
            dashboardBottom(context),
          ],
        ),
      );

  void _onPopupItemSelected(String type) async {
    switch (type) {
      case "sign_out":
        await _authService.signOut();
        break;
      default:
        break;
    }
  }

  void _goToMenu(MenuType menu) {
    Widget toMenu;
    switch (menu) {
      case MenuType.stores:
        toMenu = StoreMenu();
        break;
      case MenuType.scanner:
        toMenu = Scanner(
          userData: user,
        );
        break;
      default:
        break;
    }

    if (toMenu != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => toMenu));
    }
  }

  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    user = Provider.of<UserData>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          allCards(context),
        ],
      ),
    );
  }
}
