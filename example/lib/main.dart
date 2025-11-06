import 'package:flutter/material.dart';
import 'package:qcf_quran/qcf_quran.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QCF Quran Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const QuranDemoApp(),
    );
  }
}

class QuranDemoApp extends StatefulWidget {
  const QuranDemoApp({super.key});

  @override
  State<QuranDemoApp> createState() => _QuranDemoAppState();
}

class _QuranDemoAppState extends State<QuranDemoApp> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 1: Full Quran PageView
          QuranPageViewDemo(controller: _pageController),
          
          // Tab 2: Single Verse Demo
          const SingleVerseDemo(),
          
          // Tab 3: Search Demo
          const SearchDemo(),
          
          // Tab 4: Data Functions Demo
          const DataFunctionsDemo(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Quran Pages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Single Verse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Data Info',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class QuranPageViewDemo extends StatefulWidget {
  final PageController controller;
  
  const QuranPageViewDemo({super.key, required this.controller});

  @override
  State<QuranPageViewDemo> createState() => _QuranPageViewDemoState();
}

class _QuranPageViewDemoState extends State<QuranPageViewDemo> {
  int _currentPage = 1;
  Map<String, int>? _highlightedVerse;
  bool _showHighlight = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page info and controls
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.teal.shade50,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Page: $_currentPage / $totalPagesCount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _currentPage > 1
                            ? () {
                                widget.controller.animateToPage(
                                  _currentPage - 2,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: _currentPage < totalPagesCount
                            ? () {
                                widget.controller.animateToPage(
                                  _currentPage,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showHighlight = !_showHighlight;
                          if (_showHighlight) {
                            _highlightedVerse = {'surahNumber': 2, 'verseNumber': 7};
                          } else {
                            _highlightedVerse = null;
                          }
                        });
                      },
                      child: Text(_showHighlight ? 'Remove Highlight' : 'Highlight First Verse'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showJumpToPageDialog();
                      },
                      child: const Text('Jump to Page'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Quran PageView
        Expanded(
          child: PageviewQuran(
            controller: widget.controller,
            initialPageNumber: _currentPage,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            sp: 1.2,
            highlightedVerse: _highlightedVerse,
            highlightedColor: Colors.yellow.shade300,
            textColor: Colors.black,
            pageBackgroundColor: Colors.white,
            onLongPress: (surahNumber, verseNumber) {
              _showVerseDetails(surahNumber, verseNumber);
            },
          ),
        ),
      ],
    );
  }

  void _showJumpToPageDialog() {
    final TextEditingController pageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jump to Page'),
        content: TextField(
          controller: pageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Page Number (1-$totalPagesCount)',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final page = int.tryParse(pageController.text);
              if (page != null && page >= 1 && page <= totalPagesCount) {
                widget.controller.animateToPage(
                  page - 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }

  void _showVerseDetails(int surahNumber, int verseNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Surah $surahNumber, Verse $verseNumber'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Surah Name: ${getSurahName(surahNumber)}'),
            Text('English Name: ${getSurahNameEnglish(surahNumber)}'),
            Text('Arabic Name: ${getSurahNameArabic(surahNumber)}'),
            Text('Place of Revelation: ${getPlaceOfRevelation(surahNumber)}'),
            Text('Juz: ${getJuzNumber(surahNumber, verseNumber)}'),
            Text('Page: ${getPageNumber(surahNumber, verseNumber)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class SingleVerseDemo extends StatefulWidget {
  const SingleVerseDemo({super.key});

  @override
  State<SingleVerseDemo> createState() => _SingleVerseDemoState();
}

class _SingleVerseDemoState extends State<SingleVerseDemo> {
  int _surahNumber = 1;
  int _verseNumber = 1;
  double _fontSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Surah:'),
                            DropdownButton<int>(
                              value: _surahNumber,
                              isExpanded: true,
                              items: List.generate(114, (index) => index + 1)
                                  .map((surah) => DropdownMenuItem(
                                        value: surah,
                                        child: Text('$surah. ${getSurahNameEnglish(surah)}'),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _surahNumber = value;
                                    _verseNumber = 1;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Verse (1-${getVerseCount(_surahNumber)}):'),
                            DropdownButton<int>(
                              value: _verseNumber,
                              isExpanded: true,
                              items: List.generate(getVerseCount(_surahNumber), (index) => index + 1)
                                  .map((verse) => DropdownMenuItem(
                                        value: verse,
                                        child: Text('Verse $verse'),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _verseNumber = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Font Size:'),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 12.0,
                          max: 40.0,
                          divisions: 14,
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
                            });
                          },
                        ),
                      ),
                      Text('${_fontSize.round()}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Verse display
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surah ${getSurahName(_surahNumber)} (${getSurahNameArabic(_surahNumber)})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verse $_verseNumber',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: QcfVerse(
                            surahNumber: _surahNumber,
                            verseNumber: _verseNumber,
                            fontSize: _fontSize,
                            textColor: Colors.black,
                            backgroundColor: Colors.transparent,
                            onLongPress: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Long pressed: Surah $_surahNumber, Verse $_verseNumber',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchDemo extends StatefulWidget {
  const SearchDemo({super.key});

  @override
  State<SearchDemo> createState() => _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, int>> _searchResults = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search Quran text',
                        border: OutlineInputBorder(),
                        hintText: 'Enter Arabic or transliterated text',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _performSearch,
                    child: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Search'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Search results
          Expanded(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Results (${_searchResults.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _searchResults.isEmpty
                        ? const Center(
                            child: Text('No results found. Try searching for words like "الرحمن" or "rahman"'),
                          )
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final result = _searchResults[index];
                              final surahNumber = result['suraNumber']!;
                              final verseNumber = result['verseNumber']!;
                              
                              return ListTile(
                                title: Text(
                                  'Surah ${getSurahName(surahNumber)} - Verse $verseNumber',
                                ),
                                subtitle: Text(
                                  '${getSurahNameEnglish(surahNumber)} - Juz ${getJuzNumber(surahNumber, verseNumber)}',
                                ),
                                onTap: () {
                                  _showVerseDialog(surahNumber, verseNumber);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    if (_searchController.text.trim().isEmpty) return;
    
    setState(() {
      _isSearching = true;
    });
    
    // Simulate async search
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = searchWords(_searchController.text.trim());
      setState(() {
        _searchResults = List<Map<String, int>>.from(results['result']);
        _isSearching = false;
      });
    });
  }

  void _showVerseDialog(int surahNumber, int verseNumber) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Surah ${getSurahName(surahNumber)} - Verse $verseNumber',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: QcfVerse(
                  surahNumber: surahNumber,
                  verseNumber: verseNumber,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataFunctionsDemo extends StatelessWidget {
  const DataFunctionsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quran Data Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Constants
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quran Constants',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Total Pages', '$totalPagesCount'),
                  _buildInfoRow('Total Surahs', '$totalSurahCount'),
                  _buildInfoRow('Total Verses', '$totalVerseCount'),
                  _buildInfoRow('Total Juz', '$totalJuzCount'),
                  _buildInfoRow('Makki Surahs', '$totalMakkiSurahs'),
                  _buildInfoRow('Madani Surahs', '$totalMadaniSurahs'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // First and last surah info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'First & Last Surah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSurahInfo(1),
                  _buildSurahInfo(114),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Page info examples
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Page Information Examples',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPageInfo(1),
                  _buildPageInfo(2),
                  _buildPageInfo(604),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSurahInfo(int surahNumber) {
    return Card(
      margin: const EdgeInsets.only(top: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Surah $surahNumber: ${getSurahName(surahNumber)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('English: ${getSurahNameEnglish(surahNumber)}'),
            Text('Arabic: ${getSurahNameArabic(surahNumber)}'),
            Text('Verses: ${getVerseCount(surahNumber)}'),
            Text('Revelation: ${getPlaceOfRevelation(surahNumber)}'),
            Text('First Verse Page: ${getPageNumber(surahNumber, 1)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildPageInfo(int pageNumber) {
    final surahCount = getSurahCountByPage(pageNumber);
    final verseCount = getVerseCountByPage(pageNumber);
    
    return Card(
      margin: const EdgeInsets.only(top: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Page $pageNumber',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Surahs on page: $surahCount'),
            Text('Verses on page: $verseCount'),
          ],
        ),
      ),
    );
  }
}