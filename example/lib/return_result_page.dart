import 'package:blade/blade_navigator.dart';
import 'package:blade/logger.dart';
import 'package:blade/container/page_lifecycle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReturnResultPage extends StatefulWidget {
  const ReturnResultPage({required this.params,
    this.message});

  final Map params;
  final String? message;

  @override
  _ReturnResultPageState createState() => _ReturnResultPageState();
}

class _ReturnResultPageState extends State<ReturnResultPage>
    with PageLifecycleObserver {

  static const String _kTag = 'ReturnResultPage';

  @override
  void initState() {
    super.initState();

    Logger.log('$_kTag#initState, $this');
  }

  @override
  void didChangeDependencies() {
    Logger.log('$_kTag#didChangeDependencies, $this');
    PageLifecycle.shared.addObserver(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void onAppeared() {
    Logger.log(
        '$_kTag#onAppeared, $this');
  }

  @override
  void onDisappeared() {
    Logger.log(
        '$_kTag#onDisappeared, $this');
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
    final response = {'status': '100'};
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.blue,
        textTheme: new TextTheme(title: TextStyle(color: Colors.black)),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            // 如果有抽屉的话的就打开
            onPressed: () {
              BladeNavigator.of().pop(result: response);
            },
            // 显示描述信息
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
        title: Text('return_result_example'),
      ),
      body: Column(
        children: [
          Container(
        margin: const EdgeInsets.all(100.0),
        child: Text('result: ' + response.toString())),

          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'pop',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: ()  async {
               BladeNavigator.of().pop(result: response);
            },
          ),

          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'popUntil',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: ()  async {
              BladeNavigator.of().popUtil("flutterPage");
            },
          )]
      )
    );
  }
}
