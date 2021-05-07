import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home:MyApp()));
}

class MyApp extends StatelessWidget {
  int _selectedDestination = 0;
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
        appBar: new AppBar(
          title: new TextField(),
          backgroundColor: Colors.deepOrangeAccent,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {},
            ),
            new IconButton(
              icon: new Icon(Icons.segment),
              onPressed: () {},
            ),
          ],
        ),
        body: Center(
            child: Column(

              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(45.0),
                  color: Theme.of(context).buttonColor,
                  child: Text('Find Me',
                    style: TextStyle(
                      fontSize: 20.0, // insert your font size here
                    ),
                  ),
                  textColor: Colors.black,
                  onPressed: () {

                  },
                ),
                Container(
                  height: 20.0,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(45.0),
                  color: Theme.of(context).buttonColor,
                  child: Text('Fermata',
                    style: TextStyle(
                      fontSize: 20.0, // insert your font size here
                    ),
                  ),
                  textColor: Colors.black,
                  onPressed: () {

                  },
                ),
              ],
            )),

        drawer: new Drawer(
          child: new ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors:<Color>[
                        Colors.deepOrange,
                        Colors.deepOrangeAccent,
                      ]),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
                  ),
                  child:Container(
                    child: Column(
                      children:<Widget>[
                        Material(
                          borderRadius:BorderRadius.all(Radius.circular(50.0)),
                          elevation: 10,
                          child:Padding(padding: EdgeInsets.all(8.0),
                            child: Image.asset('assets/taxi_logo.png',width: 70,height: 70,),
                          ),),
                        Padding(padding: EdgeInsets.all(8.0),child: Text('Fermata',style: TextStyle(color: Colors.white,fontSize: 25.0),),)
                      ],
                    ),
                  )),

              Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                selected: _selectedDestination == 0,
                onTap: () => selectDestination(0),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Setting'),
                selected: _selectedDestination == 1,
                onTap: () => selectDestination(1),
              ),
              ListTile(
                leading: Icon(Icons.label),
                title: Text('About'),
                selected: _selectedDestination == 2,
                onTap: () => selectDestination(2),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Label',
                ),
              ),
              ListTile(
                leading: Icon(Icons.taxi_alert),
                title: Text('Fermata'),
                selected: _selectedDestination == 3,
                onTap: () => selectDestination(3),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                selected: _selectedDestination == 3,
                onTap: () => selectDestination(3),
              ),
            ],
          ),
        ),
        bottomNavigationBar: new BottomNavigationBar(items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Home"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text("Search"),
          )
        ]),
        floatingActionButton: new FloatingActionButton(
          onPressed: (){},
          child: new Icon(Icons.add),
        )
    );

  }
  void selectDestination(int index) {setState() {
    _selectedDestination = index;
  };

  }
}
