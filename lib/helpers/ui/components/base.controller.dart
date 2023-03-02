import 'package:flutter/material.dart';

import 'ui_state.dart';

class BaseController extends ChangeNotifier {
  UiState _state = UiState.STATIC;

  UiState get state => _state;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  void setErrorMessage(String error) {
    _errorMessage = error;
    _state = UiState.HAS_ERROR;
    notifyListeners();
  }

  void resetErrorMessages() {
    _errorMessage = null;
    _state = UiState.STATIC;
    notifyListeners();
  }

  void toggleState(UiState state) {
    _state = state;
    notifyListeners();
  }

  void onInit() {}

  @override
  // ignore: must_call_super
  void dispose() {}

  void canDispose() {
    super.dispose();
  }
}
