import 'dart:math';

import 'package:flutter/widgets.dart';

typedef KeyboardChangeListener = Function(bool isVisible);

class KeyboardListener with WidgetsBindingObserver {
  static final Random _random = Random();


  /// Колбэки, вызывающиеся при появлении и сокрытии клавиатуры
  final Map<String, KeyboardChangeListener> _changeListeners = {};
  /// Колбэки, вызывающиеся при появлении клавиатуры
  final Map<String, VoidCallback> _showListeners = {};
  /// Колбэки, вызывающиеся при сокрытии клавиатуры
  final Map<String, VoidCallback> _hideListeners = {};

  bool get isVisibleKeyboard =>
      WidgetsBinding.instance.window.viewInsets.bottom > 0;

  KeyboardListener() {
    _init();
  }



  void dispose() {
    // Удаляем текущий класс из списка наблюдателей
    WidgetsBinding.instance.removeObserver(this);
    // Очищаем списки колбэков
    _changeListeners.clear();
    _showListeners.clear();
    _hideListeners.clear();
  }


  /// При изменениях системного UI вызываем слушателей
  @override
  void didChangeMetrics() {
    _listener();
  }


  /// Метод добавления слушателей
  String addListener({
    String? id,
    KeyboardChangeListener? onChange,
    VoidCallback? onShow,
    VoidCallback? onHide,
  }) {
    assert(onChange != null || onShow != null || onHide != null);
    /// Для более удобного доступа к слушателям используются идентификаторы
    id ??= _generateId();

    if (onChange != null) _changeListeners[id] = onChange;
    if (onShow != null) _showListeners[id] = onShow;
    if (onHide != null) _hideListeners[id] = onHide;
    return id;
  }

  /// Методы удаления слушателей
  void removeChangeListener(KeyboardChangeListener listener) {
    _removeListener(_changeListeners, listener);
  }

  void removeShowListener(VoidCallback listener) {
    _removeListener(_showListeners, listener);
  }

  void removeHideListener(VoidCallback listener) {
    _removeListener(_hideListeners, listener);
  }

  void removeAtChangeListener(String id) {
    _removeAtListener(_changeListeners, id);
  }

  void removeAtShowListener(String id) {
    _removeAtListener(_changeListeners, id);
  }

  void removeAtHideListener(String id) {
    _removeAtListener(_changeListeners, id);
  }

  void _removeAtListener(Map<String, Function> listeners, String id) {
    listeners.remove(id);
  }

  void _removeListener(Map<String, Function> listeners, Function listener) {
    listeners.removeWhere((key, value) => value == listener);
  }

  String _generateId() {
    return _random.nextDouble().toString();
  }

  void _init() {
    WidgetsBinding.instance.addObserver(this); // Регистрируем наблюдателя
  }

  void _listener() {
    if (isVisibleKeyboard) {
      _onShow();
      _onChange(true);
    } else {
      _onHide();
      _onChange(false);
    }
  }

  void _onChange(bool isOpen) {
    for (KeyboardChangeListener listener in _changeListeners.values) {
      listener(isOpen);
    }
  }

  void _onShow() {
    for (VoidCallback listener in _showListeners.values) {
      listener();
    }
  }

  void _onHide() {
    for (VoidCallback listener in _hideListeners.values) {
      listener();
    }
  }
}