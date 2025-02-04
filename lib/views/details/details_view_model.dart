import 'package:flutter/material.dart';

class DetailsViewModel extends ChangeNotifier {
  DetailsViewModel();

  void init() {
    notifyListeners();
  }
}
