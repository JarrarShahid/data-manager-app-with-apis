import 'package:apis/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _refreshData() async {
    final data = await ApiService.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _addData() async {
    if (await ApiService.createData(_titleController.text, _descController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Created Successfully'),
          backgroundColor: Colors.greenAccent,
        ),
      );
      _refreshData();
    }
  }

  Future<void> _updateData(String id) async {
    if (await ApiService.updateData(id, _titleController.text, _descController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Updated Successfully'),
          backgroundColor: Colors.blue,
        ),
      );
      _refreshData();
    }
  }

  Future<void> _deleteData(String id) async {
    if (await ApiService.deleteData(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Deleted Successfully'),
          backgroundColor: Colors.redAccent,
        ),
      );
      _refreshData();
    }
  }

void _showBottomSheet(String? id) {
  if (id != null) {
    final existingData =
        _allData.firstWhere((element) => element['id'] == id);
    _titleController.text = existingData['title'];
    _descController.text = existingData['desc'];
  } else {
    _titleController.clear();
    _descController.clear();
  }

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Description"),
              keyboardType: TextInputType.multiline,
              maxLines: null, // Allows the TextField to grow dynamically
              textInputAction: TextInputAction.newline, // Shows "Enter" button
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text(id == null ? "Add Data" : "Update Data"),
              onPressed: () {
                if (id == null) {
                  _addData();
                } else {
                  _updateData(id);
                }
                _titleController.clear();
                _descController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Manager")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (ctx, index) => Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      _allData[index]['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_allData[index]['desc']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showBottomSheet(_allData[index]['id'] as String),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteData(_allData[index]['id'] as String),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showBottomSheet(null),
      ),
    );
  }
}
