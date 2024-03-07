import 'package:flutter/material.dart';
import 'package:flutter_web_test/src/menu/item.dart';

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({super.key, required this.payload});

  final Item payload;

  static const routeName = '/item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Center(
        child: Text('Item Information'),
      ),
    );
  }
}
