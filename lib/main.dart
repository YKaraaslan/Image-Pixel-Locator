import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/searchable.dart';
import 'view/show_all_on_map/show_all_on_map_view.dart';
import 'view/show_all_on_map/show_all_on_map_viewmodel.dart';
import 'view/show_selected_on_map/show_selected_on_map_viewmodel.dart';
import 'view/viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ViewModel()),
        ChangeNotifierProvider(create: (context) => ShowAllOnMapViewModel()),
        ChangeNotifierProvider(
            create: (context) => ShowSelectedOnMapViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ViewModel>().getModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Searchable(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const ColorPickerWidget(),
            //   ),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShowAllOnMapView(),
              ),
            );
          },
          child: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
