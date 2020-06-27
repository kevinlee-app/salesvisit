import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salesvisit/models/menu.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/models/visit.dart';
import 'package:salesvisit/services/auth.dart';
import 'package:salesvisit/services/database.dart';
import 'package:salesvisit/shared/constants.dart';
import 'package:salesvisit/shared/dashboard_menu_row.dart';
import 'package:salesvisit/shared/label_below_icon.dart';
import 'package:salesvisit/views/scanner/scanner.dart';
import 'package:salesvisit/views/store/store_menu.dart';
import 'package:salesvisit/views/user/user_menu.dart';
import 'package:salesvisit/views/visit/visit_details_list.dart';
import 'package:salesvisit/views/visit/visit_total_list.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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
                        icon: Icons.person,
                        label: "Users",
                        iconColor: Colors.white,
                        circleColor: Colors.blue,
                        onPressed: () => _goToMenu(MenuType.users),
                      ),
                      LabelBelowIcon(
                        icon: Icons.store,
                        label: "Stores",
                        iconColor: Colors.white,
                        circleColor: Colors.orange,
                        onPressed: () => _goToMenu(MenuType.stores),
                      ),
                      LabelBelowIcon(
                        icon: Icons.center_focus_weak,
                        label: "Scan",
                        iconColor: Colors.white,
                        circleColor: Colors.red,
                        onPressed: () => _goToMenu(MenuType.scanner),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget dashboardBottom(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 22),
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
              VisitDetailsList(),
            ]),
      );

  Widget background() => Container(
        height: deviceSize.height * 0.385,
        decoration:
            BoxDecoration(gradient: LinearGradient(colors: kitGradients)),
      );

  Widget dateText() => Text(
        '${DateFormat('EEEE, MMM d, yyyy').format(DateTime.now())}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );

  Widget allCards(BuildContext context) => Column(
        children: <Widget>[
          appBarColumn(context),
          SizedBox(height: deviceSize.height * 0.002),
          actionMenuCard(),
          SizedBox(height: deviceSize.height * 0.01),
          VisitTotalList(),
          SizedBox(height: deviceSize.height * 0.03),
          // dashboardBottom(context),
          Text(
            'VISITS',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: deviceSize.height * 0.01),
          Expanded(child: VisitDetailsList())
        ],
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
      case MenuType.users:
        toMenu = UserMenu();
        break;
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

    return MultiProvider(
      providers: [
        StreamProvider<List<UserData>>.value(
            initialData: List(), value: DatabaseService().allUsers),
        StreamProvider<List<Visit>>.value(
            initialData: List(), value: DatabaseService().visits),
      ],
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            background(),
            allCards(context),
          ],
        ),
      ),
    );
  }
}
