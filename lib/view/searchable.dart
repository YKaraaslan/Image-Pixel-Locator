import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/model/global.dart';
import 'viewmodel.dart';

class Searchable extends StatefulWidget {
  const Searchable({Key? key}) : super(key: key);

  @override
  State<Searchable> createState() => _SearchableState();
}

class _SearchableState extends State<Searchable> {
  @override
  void initState() {
    super.initState();
    context.read<ViewModel>().formKey = GlobalKey<FormState>();
    context.read<ViewModel>().textEditingController = TextEditingController();
    context.read<ViewModel>().searchList = Global.model!;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModel>(
      builder: (context, value, child) => Form(
        key: value.formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: value.textEditingController,
                onChanged: value.onChangeMethod,
              ),
              const SizedBox(height: 25),
              ListView.builder(
                itemCount: value.searchList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    value.goToMapPage(context, value.searchList[index]);
                  },
                  title: Text(value.searchList[index].name! +
                      (value.searchList[index].machines!.isNotEmpty
                          ? ' (x${value.searchList[index].machines!.length.toString()})'
                          : '')),
                  subtitle: Text(value.searchList[index].description!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
