import 'package:blade/container/page_lifecycle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blade/blade_navigator.dart';

class SimpleWidget extends StatefulWidget {
  final Map params;
  final String messages;
  final String uniqueId;

  const SimpleWidget(this.uniqueId, this.params, this.messages);

  @override
  _SimpleWidgetState createState() => _SimpleWidgetState();
}

class _SimpleWidgetState extends State<SimpleWidget>
    with PageLifecycleObserver {
  static const String _kTag = 'page_visibility';
  @override
  void didChangeDependencies() {
    final Route<dynamic> route = ModalRoute.of(context) as Route<dynamic>;
    PageLifecycle.shared.addObserver(this, route);
    print('$_kTag#didChangeDependencies, ${widget.uniqueId}, $this');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print('$_kTag#initState, ${widget.uniqueId}, $this');
    super.initState();
  }

  @override
  void onAppeared({bool isForegroundEvent = true}) {
    print('$_kTag#onPageShow, ${widget.uniqueId}, isForegroundEvent=$isForegroundEvent, $this');
  }

  @override
  void onDisappeared({bool isBackgroundEvent = true}) {
    print('$_kTag#onPageHide, ${widget.uniqueId}, isBackgroundEvent=$isBackgroundEvent, $this');
  }



  @override
  void dispose() {
    PageLifecycle.shared.removeObserver(this);
    print('$_kTag#dispose, ${widget.uniqueId}, $this');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tab_example'),
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 80.0),
                child: Text(
                  widget.messages,
                  style: TextStyle(fontSize: 28.0, color: Colors.blue),
                ),
                alignment: AlignmentDirectional.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: Text(
                  widget.uniqueId,
                  style: TextStyle(fontSize: 22.0, color: Colors.red),
                ),
                alignment: AlignmentDirectional.center,
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(30.0),
                    color: Colors.yellow,
                    child: Text(
                      'open native page',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => BladeNavigator.of().pushNativePage("native"),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(30.0),
                    color: Colors.yellow,
                    child: Text(
                      'open flutter page',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => BladeNavigator.of().pushFlutterPage("flutterPage",
                    arguments: <String, String>{'from': widget.uniqueId}),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(30.0),
                    color: Colors.yellow,
                    child: Text(
                      'open flutter page with FlutterView',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => BladeNavigator.of().pushFlutterPage("flutterPage",
                    arguments: <String, Object>{'from': widget.uniqueId, 'index': 100}),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(30.0),
                    color: Colors.yellow,
                    child: Text(
                      'Navigator.push',
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(title: Text('Navigator.push')),
                      body: Center(
                        child: TextButton(
                          child: Text('POP'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                )),
              ),
              Container(
                height: 300,
                width: 200,
                child: Text(
                  '',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                ),
              )
            ],
          ))),
    );
  }
}

