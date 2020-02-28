import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medium Reader',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value == null) {
        return;
      }
      var url = _getUrl(value);
      if (url != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostOpener(
                    url,
                  )),
        );
      }
    });
  }

  String _getUrl(String text) {
    final urlRegExp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    final urlMatches = urlRegExp.allMatches(text);
    List<String> urls = urlMatches
        .map((urlMatch) => text.substring(urlMatch.start, urlMatch.end))
        .toList();
    if (urls.length < 1) {
      return null;
    }
    return urls[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Medium Reader'),
      ),
      body: Container(
        child: Center(
          child: Text(
            "Please share a post from Medium app",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class PostOpener extends StatefulWidget {
  String postUrl = "";
  PostOpener(this.postUrl) : super();

  @override
  _PostOpener createState() => _PostOpener();
}

class _PostOpener extends State<PostOpener> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.postUrl,
      appBar: new AppBar(
        title: const Text('Medium Reader'),
      ),
      withZoom: true,
      withLocalStorage: true,
      clearCache: true,
      clearCookies: true,
      hidden: false,
      initialChild: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
