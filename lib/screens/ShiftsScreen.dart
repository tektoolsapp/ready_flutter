import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/components/WebserviceFail.dart';
import 'package:flutter_ready_prod/models/Shift.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';

class ShiftsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
          title: Text('Current Shifts')
        ),
        drawer: AppDrawer().build(context),
        bottomNavigationBar: BottomNav(),
        body: FutureBuilder(
          future: Webservice().load(Shift.all),
          builder: (context, snapshot) {
            
            if(snapshot.hasError) {
              return WebserviceFail();
            }

            if(snapshot.hasData) {
              
              
              
              

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return _buildShift(snapshot.data[index], context);
                }
              );
            }
            return Loading();
          }
        )
    );
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