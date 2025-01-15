import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:main/entity/fnb.dart';
import 'package:main/client/FnbClient.dart';
import 'package:speech_to_text/speech_to_text.dart' ;

List<String> menu = <String>[
  'ALL',
  'FOOD',
  'BEVERAGES',
];

// Define a StateProvider for selected category and search query
final selectedCategoryProvider = StateProvider<String>((ref) => 'ALL');
final searchQueryProvider = StateProvider<String>((ref) => '');

class FnbList extends ConsumerStatefulWidget {
  final int tabIndex;
  FnbList({super.key, this.tabIndex = 0});

  @override
  _FnbListState createState() => _FnbListState();
}

class _FnbListState extends ConsumerState<FnbList> {
  final listFnbProvider = FutureProvider<List<Fnb>>((ref) async {
    return await FnbClient.fetchAll();
  });

  bool _speechEnabled = false;

  final SpeechToText _speechToText = SpeechToText();
  String _wordsSpoken = "";
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async{
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async{
    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
    setState(() {
      
    });
  }

  void _onSpeechResult(result){
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _searchController.text = _wordsSpoken;
      ref.read(searchQueryProvider.notifier).state = _wordsSpoken;
    });
  }

  void _stopListening() async{
    await _speechToText.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final fnbListener = ref.watch(listFnbProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 33, 61, 41),
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Text(
                  '&',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(232, 213, 156, 1),
                    height: 1.0,
                  ),
                ),
                Text(
                  'Beverages',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'images/appbarMenu/hand.png',
                  height: 50,
                ),
                Image.asset(
                  'images/appbarMenu/popcorn.png',
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
      body: fnbListener.when(
        error: (err, s) => Center(child: Text(err.toString())),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (fnbs) {
          final menuMakanan = fnbs.where((fnb) => fnb.jenis == "food").toList();

          final filteredMenu = fnbs.where((item) {
            final isCategoryMatch = selectedCategory == 'ALL' ||
                (selectedCategory == 'FOOD' && item.jenis == 'Makanan') ||
                (selectedCategory == 'BEVERAGES' && item.jenis == 'Minuman');
            final isSearchMatch =
                item.nama_menu.toLowerCase().contains(searchQuery.toLowerCase());
            return isCategoryMatch && isSearchMatch;
          }).toList();

          return Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      items: menu.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          ref.read(selectedCategoryProvider.notifier).state = newValue;
                        }
                      },
                    ),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _speechToText.isListening ? Icons.mic_off : Icons.mic,
                              color: Colors.black,
                            ),
                            onPressed: _speechToText.isListening ? _stopListening : _startListening,
                          ),
                        ),
                        onChanged: (value) {
                          ref.read(searchQueryProvider.notifier).state = value;
                        },
                        controller: _searchController,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredMenu.length,
                  itemBuilder: (context, index) {
                    final item = filteredMenu[index];
                    return GestureDetector(
                      onTap: () => _showItemDetail(context, item),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                item.gambar,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nama_menu,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Rp. ${item.harga}',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showItemDetail(BuildContext context, Fnb item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(item.gambar),
              SizedBox(height: 16),
              Text(
                item.nama_menu,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp. ${item.harga}',
                style: TextStyle(fontSize: 20, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
