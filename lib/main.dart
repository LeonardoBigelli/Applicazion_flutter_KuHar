//V.1 CON PROVIDER
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:ku_har_app/interpreter.dart';
import 'package:ku_har_app/window.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ku_har_app/contatore.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Window()),
      ChangeNotifierProvider(
          create: (context) => InterpreterTf('model_act_10_classes.tflite')),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green, // Set the app's primary theme color
      ),
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  // non ha senso, togliere lo stato
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Simple App'),
        ),
        body: Center(
          child: Column(
            children: [
              Consumer<Window>(builder: (context, val, child) {
                return Text("prova ${val.windownData[0]}");
              }),
              Consumer<InterpreterTf>(builder: (context, val, child) {
                return Text("prova ${val.output}");
              }),
              ElevatedButton(
                onPressed: () =>
                    Provider.of<Window>(context, listen: false).timerWindow(),
                child: const Text(
                  'incrementa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                  onPressed: () => {
                        Provider.of<InterpreterTf>(context, listen: false)
                            .runIference
                      }, //come passo il parametro della finestra temporale??
                  child: const Text(
                    'Effettua inferenza',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ));
  }
} 


/* Codice per i servizi in background
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Simple App'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  await service.startService();
                },
                child: const Text('Start Background Service'),
              ),
            ],
          ),
        ));
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

void onStart(ServiceInstance service) {
  service.on('task').listen((event) {
    callback();
  });
  Timer.periodic(const Duration(seconds: 10), (timer) {
    service.invoke('task');
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  service.on('task').listen((event) {
    callback();
  });
  Timer.periodic(const Duration(seconds: 50), (timer) {
    service.invoke('task');
  });
  return true;
}

void callback() async {
  try {
    print('Background');

    /* List<GyroscopeEvent> dataGyr = [];
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (dataGyr.length < 200) {
        dataGyr.add(event);
      } else {
        // Esegui un'azione con i dati del giroscopio
        // Ad esempio, invia i dati a un server o salvali localmente
        print("Finestra piena!");
      }
    });*/
  } catch (e) {
    print('Error in background');
  }
}
*/
