import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Search App',
      home: PDFSearchScreen(),
    );
  }
}

class PDFSearchScreen extends StatefulWidget {
  @override
  _PDFSearchScreenState createState() => _PDFSearchScreenState();
}

class _PDFSearchScreenState extends State<PDFSearchScreen> {
  String query = '';
  PDFDoc? _pdfDoc;
  List<String> _searchResults = [];

  // Function to load and parse the PDF
  Future<void> loadPDF() async {
    _pdfDoc = await PDFDoc.fromAsset('assets/your_pdf_file.pdf');
    // Or from a file: _pdfDoc = await PDFDoc.fromFile(File('path/to/your/pdf'));
    // Or from a URL: _pdfDoc = await PDFDoc.fromURL('http://www.africau.edu/images/default/sample.pdf');
  }

  // Function to search the PDF
  void searchPDF(String query) async {
    if (_pdfDoc == null || query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    List<String> results = [];
    String text = await _pdfDoc!.text;

    // Simple case-sensitive search
    if (text.contains(query)) {
      results.add(query);
    }

    // Update the state with the search results
    setState(() {
      _searchResults = results;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search in PDF Document'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
                searchPDF(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
