import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TapPage(),
    );
  }
}

class TapPage extends StatefulWidget {
  const TapPage({Key? key}) : super(key: key);

  @override
  _TapPageState createState() => _TapPageState();
}

class _TapPageState extends State<TapPage> {
  List<Widget> list = [
    IndexPage(),
    SettingPage(),
  ];

  int _currentIndex = 0;
  Color _favroite_color = Colors.black54;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(
            "二刺螈",
          ),
          leading: GestureDetector(
            onTap: () {
              globalKey.currentState!.openDrawer();
            },
            child: Icon(
              Icons.menu,
            ),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      this._favroite_color = Colors.red;
                    });
                  },
                  child: Icon(
                    Icons.favorite,
                    color: this._favroite_color,
                  ),
                )),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: Image.asset("assets/images/profile.png"),
                        padding: EdgeInsets.all(10),
                      ),
                      Text(
                        '据说每10个程序员中就有2个二刺螈',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  )),
              ListTile(
                title: Text('关于'),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationName: "二刺螈",
                      applicationIcon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      applicationVersion: "v1.0.0",
                      children: [Text("\n这是一个软件\n开发者：heeeepin@gmail.com")],
                      applicationLegalese: '© 2021 Company');
                },
              ),
            ],
          ),
        ),
        body: this.list[this._currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: this._currentIndex,
          onTap: (index) {
            setState(() {
              this._currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "设置")
          ],
        ));
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              ImageContent(),
              SizedBox(
                height: 140,
              ),
              Text(
                "仅供测试，请于下载24小时内删除",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              DateTimeWidget(),
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ],
          ),

        )
    );
  }
}

class ImageContent extends StatefulWidget {
  const ImageContent({
    Key? key,
  }) : super(key: key);

  @override
  _ImageContentState createState() => _ImageContentState();

}

class _ImageContentState extends State<ImageContent> {
  String url = "https://api.ixiaowai.cn/mcapi/mcapi.php";
  Widget _pic = Image.asset("assets/images/default.png");

  void initState() {
    super.initState();
    _pic = Image.network(url,fit: BoxFit.cover,);
  }

  refresh() async {

    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();

    setState(() {
      _pic = Image.memory(bytes,fit: BoxFit.cover,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: this._pic,
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                this.refresh();
              });
            },
            child: Text("下一个")),
      ],
    );
  }
}

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({Key? key}) : super(key: key);

  @override
  _DateTimeWidgetState createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  _DateTimeWidgetState() {
    this.startClock();
  }

  DateTime now = DateTime.now();
  static const CLOCK_INTERVAL = Duration(seconds: 1);

  startClock() {
    Timer.periodic(CLOCK_INTERVAL, (Timer t) {
      if (!mounted) {
        return;
      }
      setState(() {
        this.now = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${this.now}",
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("这是设置页"),
    );
  }
}
