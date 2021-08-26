import 'package:blade/blade_navigator.dart';
import 'package:blade/logger.dart';
import 'package:blade/container/page_lifecycle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlutterPage extends StatefulWidget {
  const FlutterPage({required this.params,
    this.message});

  final Map params;
  final String? message;

  @override
  _FlutterPageState createState() => _FlutterPageState();
}

class _FlutterPageState extends State<FlutterPage>
    with PageLifecycleObserver {

  static const String _kTag = 'FlutterPage';

  @override
  void initState() {
    super.initState();
    Logger.log('$_kTag#initState(), $this');
  }

  @override
  void didChangeDependencies() {
    Logger.log('$_kTag#didChangeDependencies(), $this');
    PageLifecycle.shared.addObserver(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void onAppeared() {
    Logger.log(
        '$_kTag#onAppeared(), $this');
  }

  @override
  void onDisappeared() {
    Logger.log(
        '$_kTag#onDisappeared(), $this');
  }

  @override
  void dispose() {
    PageLifecycle.shared.removeObserver(this);
    Logger.log('$_kTag#dispose(), $this');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? message = widget.message;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        textTheme: new TextTheme(title: TextStyle(color: Colors.black)),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            // 如果有抽屉的话的就打开
            onPressed: () {
              BladeNavigator.of().pop();
            },
            // 显示描述信息
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
        title: Text('flutter_boost_example'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          margin: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text.rich(TextSpan(text: '', children: <TextSpan>[
                  TextSpan(
                      text: message ??
                          "This is a flutter activity.",
                      style: TextStyle(color: Colors.blue)),
                  TextSpan(
                      text: "\nparams: ${widget.params}",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ])),
                alignment: AlignmentDirectional.center,
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open native page',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: ()  async {
                  var result = await BladeNavigator.of()
                    .pushNativePage("nativePage",arguments: {'from': 'flutter page'});
                  print(result);
                },
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'open flutterPage',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => BladeNavigator.of()
                    .pushFlutterPage("flutterPage", arguments: {'status': 101}),
              ),

              InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.yellow,
                      child: Text(
                        'open willPop demo',
                        style: TextStyle(fontSize: 22.0, color: Colors.black),
                      )),
                  onTap: () =>
                      BladeNavigator.of().pushFlutterPage("willPop")),

              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'push flutter widget',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () {
                  Navigator.push<dynamic>(context,
                      MaterialPageRoute<dynamic>(builder: (_) => PushWidget()));
                },
              ),
              InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.yellow,
                      child: Text(
                        'returning result from flutter page',
                        style: TextStyle(fontSize: 22.0, color: Colors.black),
                      )),
                  // onTap: () async {
                  //   final result = await BoostNavigator.of()
                  //       .push("returnData", withContainer: true);
                  //   print('Get result: $result');
                  // }),
                  onTap: () => BladeNavigator.of()
                      .pushFlutterPage("returnResult", arguments: {'param1': '100'})
                      .then((onValue) => print('Get result: $onValue'))),
            ],
          ),
        ),
      ),
    );
  }
}

class PushWidget extends StatefulWidget {
  @override
  _PushWidgetState createState() => _PushWidgetState();
}

class _PushWidgetState extends State<PushWidget> {
  VoidCallback? _backPressedListenerUnsub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _backPressedListenerUnsub?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              // 如果有抽屉的话的就打开
              onPressed: () {
                BladeNavigator.of().pop();
              },
              // 显示描述信息
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          }),
          title: Text('flutter_boost_example'),
        ),
        body: Container(
          color: Colors.red,
          width: 100,
          height: 100,
        ));
  }
}
