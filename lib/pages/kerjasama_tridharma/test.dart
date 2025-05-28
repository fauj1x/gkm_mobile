import 'package:flutter/material.dart';
import 'package:gkm_mobile/models/test.dart';
import 'package:gkm_mobile/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _getData();
  }

  int userId = 0;
  ApiService apiService = ApiService();
  String endPoint = "test";
  List<TestModel> dataList = [];
  int? editingId;

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  Future<void> _getData() async {
    try {
      final List<TestModel> data = await apiService.getData(TestModel.fromJson, endPoint);
      setState(() {
        dataList = data;
      });
    } catch (e) {
      print("Error getting data: $e");
    }
  }

  void _submitText() {
    final text = _textController.text;
    if (editingId == null) {
      final Map<String, dynamic> newData = {
        'user_id': userId,
        'text': text,
      };
      _addData(newData);
    } else {
      final Map<String, dynamic> updateData = {
        'user_id': userId,
        'text': text,
      };
      _updateData(editingId!, updateData);
    }
  }

  Future<void> _addData(Map<String, dynamic> newData) async {
    try {
      await apiService.postData(TestModel.fromJson, newData, endPoint);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil dikirim")),
      );
      _textController.clear();
      _getData();
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  Future<void> _updateData(int id, Map<String, dynamic> updateData) async {
    try {
      await apiService.updateData(
        TestModel.fromJson,
        dataList[id].id,
        updateData,
        endPoint,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil diperbarui")),
      );
      setState(() {
        editingId = null;
      });
      _textController.clear();
      _getData();
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      await apiService.deleteData(
        dataList[id].id,
        endPoint,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil dihapus")),
      );
      _getData();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  void _editData(TestModel data) {
    setState(() {
      editingId = dataList.indexOf(data);
      _textController.text = data.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Sederhana")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Masukkan teks di sini',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitText,
              child: Text(editingId == null ? "Kirim" : "Update"),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final data = dataList[index];
                  return ListTile(
                    title: Text(data.text),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editData(data),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteData(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}