import 'package:blade/blade_navigator.dart';
import 'package:blade/logger.dart';
import 'package:blade/container/page_visibility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReturnResultPage extends StatefulWidget {
  const ReturnResultPage({required this.params,
    this.message, required this.uniqueId});

  final Map params;
  final String? message;
  final String uniqueId;

  @override
  _ReturnResultPageState createState() => _ReturnResultPageState();
}

class _ReturnResultPageState extends State<ReturnResultPage>
    with PageVisibilityObserver {

  static const String _kTag = 'page_visibility';

  @override
  void initState() {
    super.initState();
    Logger.log('$_kTag#initState, ${widget.uniqueId}, $this');
  }

  @override
  void didChangeDependencies() {
    Logger.log('$_kTag#didChangeDependencies, ${widget.uniqueId}, $this');
    PageVisibilityBinding.instance.addObserver(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PageVisibilityBinding.instance.removeObserver(this);
    Logger.log('$_kTag#dispose~, ${widget.uniqueId}, $this');
    super.dispose();
  }

  @override
  void onPageCreate() {
    Logger.log('$_kTag#onPageCreate, ${widget.uniqueId}, $this');
  }

  @override
  void onPageDestory() {
    Logger.log('$_kTag#onPageDestory, ${widget.uniqueId}, $this');
  }

  @override
  void onPageShow({bool isForegroundEvent = true}) {
    Logger.log(
        '$_kTag#onPageShow, ${widget.uniqueId}, isForegroundEvent=$isForegroundEvent, $this');
  }

  @override
  void onPageHide({bool isBackgroundEvent = true}) {
    Logger.log(
        '$_kTag#onPageHide, ${widget.uniqueId}, isBackgroundEvent=$isBackgroundEvent, $this');
  }

  @override
  Widget build(BuildContext context) {
    final String? message = widget.message;
    final response = {'status': '100'};
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
              BladeNavigator.of().pop(result: response);
            },
            // 显示描述信息
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
        title: Text('return_result_example'),
      ),
      body: Container(
        height: 1000,
        margin: const EdgeInsets.all(24.0),
        child: Text(response.toString()),
      )
    );
  }
}
