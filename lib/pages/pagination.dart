import 'package:flutter/material.dart';
import '../utils/Colors.dart';
import 'Api.dart';
import 'card.dart';

class PaginatedList extends StatefulWidget {
  @override
  _PaginatedListState createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  final ApiService apiService = ApiService(baseUrl: 'https://dummyjson.com/users');
  List<dynamic> _data = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _limit = 10;
  int _totalPages = 1;
  bool _showAllPages = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await apiService.fetchData(_currentPage, _limit);
      final List<dynamic> fetchedData = response['users'];
      final int totalItems = response['total'];
      setState(() {
        _totalPages = (totalItems / _limit).ceil();
        _data = fetchedData;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
      _data.clear();
    });
    _fetchData();
  }

  List<Widget> _buildPageButtons(double width) {
    List<Widget> buttons = [];
    int pagesToShow = _showAllPages ? _totalPages : 5;
    double buttonWidth = width * 0.10;

    for (int i = 1; i <= pagesToShow; i++) {
      buttons.add(
        SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            onPressed: _currentPage == i ? null : () => _goToPage(i),
            child: Text('$i'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textStyle: TextStyle(fontSize: 12),
              minimumSize: Size(buttonWidth, buttonWidth),
            ),
          ),
        ),
      );
    }

    if (!_showAllPages && _totalPages > 5) {
      buttons.add(
        SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _showAllPages = true;
              });
            },
            child: Icon(Icons.arrow_forward),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size(buttonWidth, buttonWidth),
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF7fcfbc),
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        title: Center(
          child: Text(
            'Users List',
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.08,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Icon(
            Icons.logout,
            color: Colors.white,
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: width * 0.1,
                        child: Icon(
                          Icons.account_circle,
                          size: width * 0.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "ADMIN",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  "Home",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout_sharp),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading && _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return DataCard(data: _data[index]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageButtons(width),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
