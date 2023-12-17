import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoPlantScreen extends StatelessWidget {
  const NoPlantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info,
            color: Colors.grey,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.no_plants,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context)!.no_plants_description,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
