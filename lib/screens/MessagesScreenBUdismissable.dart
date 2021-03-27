import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/data.dart';
import 'package:flutter_ready_prod/models/chat.dart';
import 'package:flutter_ready_prod/utils.dart';
import 'package:flutter_ready_prod/widget/dismissable_widget.dart';

class MessagesScreen extends StatefulWidget {
  final String title;

  const MessagesScreen({
    @required this.title,
  });

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Chat> items = List.of(Data.chats);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Messages"),
      actions: [
        IconButton(
          icon: Icon(Icons.restore),
          onPressed: () {
            setState(() {
              items = List.of(Data.chats);
            });
          },
        ),
      ],
    ),
    body: ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
        color: Colors.black
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return DismissibleWidget(
          item: item,
          child: buildListTile(item),
          onDismissed: (direction) =>
              dismissItem(context, index, direction),
        );
      },
    ),
  );

  void dismissItem(
    BuildContext context,
    int index,
    DismissDirection direction,
  ) {
    setState(() {
      items.removeAt(index);
    });

    switch (direction) {
      case DismissDirection.endToStart:
        Utils.showSnackBar(context, 'Chat has been deleted');
        break;
      case DismissDirection.startToEnd:
        Utils.showSnackBar(context, 'Chat has been archived');
        break;
      default:
        break;
    }
  }

  Widget buildListTile(Chat item) => ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(item.urlAvatar),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(item.message)
          ],
        ),
        onTap: () {},
      );
}