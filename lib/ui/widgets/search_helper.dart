import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SearchHelper {
  final Function(String) onSearch;
  final VoidCallback onToggleSearch;

  SearchHelper({required this.onSearch, required this.onToggleSearch});

  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  bool _isSearching = false;
  final int _maxSearchHistory = 10;
  Timer? _debounce;

  bool get isSearching => _isSearching;

  Future<void> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _searchHistory = prefs.getStringList('searchHistory') ?? [];
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', _searchHistory);
  }

  void _addToSearchHistory(String query) {
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);
    if (_searchHistory.length > _maxSearchHistory) {
      _searchHistory.removeLast();
    }
    _saveSearchHistory();
  }

  void removeFromSearchHistory(String query) {
    _searchHistory.remove(query);
    _saveSearchHistory();
  }

  void performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      onSearch(query);
      if (query.isNotEmpty && _isSearching) {
        _addToSearchHistory(query);
      }
    });
  }

  void toggleSearch() {
    if (_isSearching) {
      _searchController.clear();
    }
    _isSearching = !_isSearching;
    onToggleSearch();
  }

  Widget buildSearchField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 40,
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search movies...',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.amber),
          filled: true,
          fillColor: Colors.grey[850],
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: performSearch,
      ),
    );
  }

  Widget buildSearchHistoryList() {
    return _searchHistory.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            'Recent Searches',
            style: TextStyle(color: Colors.amber, fontSize: 15),
          ),
        ),
        Wrap(
          spacing: 8,
          children: _searchHistory.map((query) {
            return InputChip(
              label: Text(query),
              onPressed: () {
                _searchController.text = query;
                performSearch(query);
              },
              onDeleted: () => removeFromSearchHistory(query),
              backgroundColor: Colors.grey[800],
              labelStyle: const TextStyle(color: Colors.white),
              deleteIconColor: Colors.white70,
            );
          }).toList(),
        ),
      ],
    )
        : const SizedBox.shrink();
  }

  void dispose() {
    _debounce?.cancel();
  }
}