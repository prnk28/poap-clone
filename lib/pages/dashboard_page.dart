import 'package:flutter/material.dart';
import 'package:motor_flutter/motor_flutter.dart';
import 'package:motor_flutter_starter/pages/profile_page.dart';
import '../models/action.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: const Icon(Icons.person)),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Dashboard"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Publish Schema"),
            onTap: () async {
              final schema = Schema();
              schema.fields.add(SchemaField(name: "Event Name", fieldKind: SchemaFieldKind(kind: Kind.STRING)));
              schema.fields.add(SchemaField(name: "Date", fieldKind: SchemaFieldKind(kind: Kind.STRING)));
              schema.fields.add(SchemaField(name: "OLC", fieldKind: SchemaFieldKind(kind: Kind.STRING)));
              final fields = <String, SchemaFieldKind>{
                "Event Name": SchemaFieldKind(kind: Kind.STRING),
                "Date": SchemaFieldKind(kind: Kind.STRING),
                "OLC": SchemaFieldKind(kind: Kind.STRING),
              };
              final resp = await MotorFlutter.to.publishSchema("POAP", fields);
              print(resp);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text("Fetch Schema and Create Bucket"),
            onTap: () async {
              await _fetchSchema();
            },
          )
        ],
      ),
    );
  }

  _fetchSchema() async {
    final resp = await MotorFlutter.query.whatIs('did:snr:125488a3-3e79-4921-8118-35421d457f68', MotorFlutter.to.address.value);
    print(resp);
    if (resp == null) {
      return;
    }
    final schema = resp.schema;
    final doc = schema.newDocument("Cal Hacks");
    doc.set("Event Name", "Cal Hacks");
    doc.set("Date", "2022-10-15");
    doc.set("OLC", "V75V+8Q");

    final bucket = await MotorFlutter.to.createBucket("POAP");
    final publishedDoc = await bucket.add(doc);
    print(publishedDoc?.uri);
  }
}
