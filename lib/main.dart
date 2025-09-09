import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';


void main() {
  //debugPaintSizeEnabled = true;
  runApp(const MyApp());
}


class GlassWidget extends StatelessWidget {
  final int counter;
  final int goal;

  const GlassWidget({super.key, required this.counter, required this.goal});

  @override
  Widget build(BuildContext context) {
    

    return Stack(
      alignment: Alignment.center,
      children: [
        

        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: 240,
          ),
          child: Text(
            'Glasses logged: $counter / $goal',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            
          ),
        )
      ],
    );
  }
}


class GlassPainter extends CustomPainter {
  final double progress;

  GlassPainter(this.progress);

  final Paint _paint = Paint()
    ..color = const Color.fromARGB(255, 100, 171, 229)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final double fillHeight = size.height * progress;

    canvas.drawRect(
      Rect.fromLTWH(0, size.height - fillHeight, size.width, fillHeight),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant GlassPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 145, 201)),
      ),
      home: const MyHomePage(title: 'Mears Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int setGoal = 16;

  final GlobalKey logButtonKey = GlobalKey();
  final GlobalKey resetButtonKey = GlobalKey();
  final GlobalKey titleKey = GlobalKey();
  final GlobalKey glassesTextKey = GlobalKey(); // Add key for glasses text
  final GlobalKey changeGoalKey = GlobalKey(); // Add key for change goal button

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter < setGoal) _counter++;
    });
  }

  void _resetHydration(){
    setState((){
      _counter = 0;
    });
  }
  
  double getWidgetY(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      return position.dy;
    }
    return -1; // Not found
  }

  Color getTextColor(double textTop, double waterFillHeight) {
    return waterFillHeight > textTop - 20? Colors.white : Colors.black;
  }

  Future<void> _changeGoalDialog() async {
  int? newGoal = setGoal;
  TextEditingController controller = TextEditingController(text: setGoal.toString());
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Set Hydration Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Enter number of glasses'),
          onChanged: (value) {
            newGoal = int.tryParse(value) ?? setGoal;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newGoal != null && newGoal! > 0) {
                setState(() {
                  setGoal = newGoal!;
                  if (_counter > setGoal) _counter = setGoal;
                });
              }
              Navigator.of(context).pop();
            },
            child: Text('Set'),
          ),
        ],
      );
    },
  );
}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {}); // Triggers rebuild after layout
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _counter / setGoal;
    final screenHeight = MediaQuery.of(context).size.height;
    final waterFillHeight =(screenHeight * progress);
    final buttonHeight = 48.0; 
    final titleHeight = 60.0;

    final logButtonY = screenHeight - getWidgetY(logButtonKey);
    final resetButtonY =screenHeight - getWidgetY(resetButtonKey);
    final titleY = screenHeight - getWidgetY(titleKey);
    final glassesTextY = screenHeight - getWidgetY(glassesTextKey);
    final changeGoalTextY = screenHeight - getWidgetY(changeGoalKey);

    final logButtonTextColor = getTextColor(logButtonY, waterFillHeight);
    final resetButtonTextColor = getTextColor(resetButtonY, waterFillHeight);
    final titleTextColor = getTextColor(titleY, waterFillHeight);
    final glassesTextColor = getTextColor(glassesTextY, waterFillHeight);
    final changeGoalTextColor = getTextColor(changeGoalTextY, waterFillHeight);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: GlassPainter(progress),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                SizedBox(
                  height: titleHeight,
                  child: Text(
                    'Stay Hydrated',
                    key: titleKey,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: titleTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 32),
                SizedBox(
                  height:buttonHeight,
                  child:
                  Text(
                    'Glasses today: $_counter / $setGoal',
                    key: glassesTextKey,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: glassesTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: 160,
                  height: buttonHeight,
                  child: ElevatedButton(
                    key: logButtonKey,
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.transparent,
                      foregroundColor: logButtonTextColor,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    child: Text(
                      'Log a glass',
                      style: TextStyle(
                        color: logButtonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: 12),
                SizedBox(
                  width: 160,
                  height: buttonHeight,
                  child: ElevatedButton(
                    key: resetButtonKey,
                    onPressed: _resetHydration,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.transparent,
                      foregroundColor: resetButtonTextColor,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: resetButtonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: 180,
                  height: buttonHeight,
                  child: ElevatedButton(
                    key:changeGoalKey,
                    onPressed: _changeGoalDialog,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    child: Text(
                      'Change Goal',
                      style: TextStyle(
                        color: changeGoalTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
