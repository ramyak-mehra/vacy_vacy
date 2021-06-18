import 'package:flutter/material.dart';
import 'package:vacy/home.dart';
import 'package:url_launcher/link.dart';

class WebView extends StatelessWidget {
  final Widget child;

  const WebView({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Size _size;
    if (deviceSize.height > 900) {
      _size = Size(900 / 2.1, 900);
    } else {
      _size = Size(deviceSize.height / 2.1, deviceSize.height);
    }
    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: Link(
              target: LinkTarget.blank,
              builder:
                  (BuildContext context, Future<void> Function() followLink) {
                return TextButton(
                  child: Text('Twitter @mehraramyak'),
                  onPressed: followLink,
                );
              },
              uri: Uri.parse('https://twitter.com/mehraramyak'),
            ),
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Text(
                'Tell me you are bad at UI/UX without telling me you are bad at UI/UX. 😌I\'ll go first'),
          ),
          SizedBox(
            width: 50,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.purple[900],
                    width: deviceSize.height > 900 ? 10 : 2)),
            height: _size.height,
            width: _size.width,
            child: child,
          ),
          SizedBox(
            width: 20,
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Text(
                'Who told you you need responsive design when you can do this. 😌'),
          ),
        ],
      ),
    );
  }
}
