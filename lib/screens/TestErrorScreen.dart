import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/models/Shift.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';

class TestErrorScreen extends StatefulWidget {
  @override
  _TestErrorScreenState createState() => new _TestErrorScreenState();
}

class _TestErrorScreenState extends State<TestErrorScreen> {
  
  Future<List> _future; // Starts as null
  Object _lastError; // Starts as null

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Current Swings')
      ),
      drawer: AppDrawer().build(context),
      bottomNavigationBar: BottomNav(),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _futureBuilder(),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _futureBuilder() {
    return new FutureBuilder<List>(
      future: asyncFunc(), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (_lastError != null) {
          return new Text('Last Error: ${_lastError}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('Press button to start');
          case ConnectionState.waiting:
            return const Text('Awaiting result...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              
              print('Result: ${snapshot.data}');
              
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return _buildShift(snapshot.data[index], context);
                }
              );
        }
      },
    );
  }

  Widget _button() {
    return new RaisedButton(
      child: const Text('ASYNC ACTION'),
      onPressed: _startAsync,
    );
  }

  void _startAsync() {
    setState(() {
      _lastError = null;
      // _future = asyncFunc(); // Won't throw;
      //_future = asyncFunc(something: true); // Will throw
      _future = asyncFunc().catchError((err) {
        // Note - this will be set outside of setState,
        // but the build() call won't have ran yet.
        _lastError = err;
      });
    });
  }

  Widget _buildShift (Shift shift, context){   
    return Column (
      children: <Widget> [
        Ink(
        color: shift.status == 'N' ? Colors.lightGreen : Colors.transparent,  
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          title: Text(
            shift.start + " - " + shift.type + " - " + shift.site,
            style: TextStyle(fontSize: 16.0),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/shiftDetails',
              arguments: shift 
            );
          },
          ),
        ),
        Container(
          decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.blueGrey[100]),
          ),
          ),
        ) 
      ],
    );
  }
}

Future<List> asyncFunc() async {
  
  final result = await Shift().allShifts();
  
  // ignore: unrelated_type_equality_checks
  if (result == false) {
    throw new FormatException('thrown-error');
  }

  //final dur = const Duration(seconds: 2);
  //return new Future.delayed(dur, () => result);
  
  return result;
}