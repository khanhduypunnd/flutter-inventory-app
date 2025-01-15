import 'package:flutter/material.dart';
import 'side/right_side.dart';
import 'side/left_side.dart';

class ClientLogin extends StatefulWidget {
  const ClientLogin({super.key});

  @override
  State<ClientLogin> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {

  late double maxWidth, maxHeight;
  late Size preferredAppbarSize;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
    preferredAppbarSize = Size(maxWidth * 0.8, maxHeight * 0.18);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const Expanded(flex: 1, child: RightSide()),
          Expanded(flex: 1, child: LeftSide())
        ],
      ),
    );
  }
}
