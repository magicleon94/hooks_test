import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hello'),
            Expanded(child: Home()),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulHookWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var previousPage = 0;
  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.of(context).size.width;
    print('Building Home');
    final pageController = usePageController(viewportFraction: 0.9);
    // ignore: close_sinks
    final rotationController = useStreamController<double>();
    useEffect(() {
      void _callback() {
        if (pageController.page.toInt() == pageController.page) {
          previousPage = pageController.page.toInt();
        }
        rotationController.add(pageController.page - previousPage);
      }

      pageController.addListener(_callback);
      return () => pageController.removeListener(_callback);
    }, [pageController, widget.key]);

    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 1),
          Expanded(
            child: Center(
              child: PageView.builder(
                itemCount: 10,
                controller: pageController,
                itemBuilder: (_, i) => Card(
                  color: i % 2 == 0 ? Colors.blueAccent : Colors.teal,
                  child: Center(child: Text(i.toString())),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Expanded(
              flex: 3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var i = 0; i < 5; i++)
                    HookBuilder(
                      builder: (ctx) {
                        print('Building HookBuilder');
                        final rotation = useStream(rotationController.stream,
                            initialData: .0);
                        return Center(
                          child: Container(
                            width: viewportWidth * 0.2,
                            height: viewportWidth * 0.2,
                            margin: EdgeInsets.symmetric(
                                horizontal: viewportWidth * 0.01),
                            child: Transform.rotate(
                              angle: pi * (rotation.data ?? 0),
                              child: Container(
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                ],
              )),
        ],
      ),
    );
  }
}
