import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../models/calling_list_model.dart';
import '../services/calling_list_service.dart';

/// Holds the user's calling lists, the selected list and its details.
class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(this._service);

  final CallingListService _service;

  bool _isLoading = false;
  String? _error;
  List<CallingListModel> _lists = [];
  CallingListModel? _selected;
  CallingListDetails? _details;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CallingListModel> get lists => _lists;
  CallingListModel? get selected => _selected;
  CallingListDetails? get details => _details;

  int get total =>
      _details == null ? 0 : _details!.pending + _details!.called + _details!.rescheduled;

  Future<void> load(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _lists = await _service.getLists(userId);
      if (_lists.isEmpty) {
        _selected = null;
        _details = null;
      } else {
        final keep = _selected?.id;
        _selected = _lists.firstWhere((l) => l.id == keep, orElse: () => _lists.first);
        _details = await _service.getListDetails(_selected!.id);
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectList(CallingListModel list) async {
    _selected = list;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _details = await _service.getListDetails(list.id);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _lists = [];
    _selected = null;
    _details = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
