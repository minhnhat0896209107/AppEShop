
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MomoScreen extends StatefulWidget {
  const MomoScreen({Key? key}) : super(key: key);

  @override
  State<MomoScreen> createState() => _MomoScreenState();
}

class _MomoScreenState extends State<MomoScreen> {
  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const WebView(
       initialUrl: 'https://developers.momo.vn/v3/download/?fbclid=IwAR0iCTrhY0RClCpDWOulMXtXR2Y5YCSsU5V0V9_KN_7fJge3umHK7HeHVMM',
     );
  }
}