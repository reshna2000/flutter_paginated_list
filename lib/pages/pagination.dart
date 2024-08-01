import 'package:flutter/material.dart';
import '../utils/Colors.dart';
import 'Api.dart';
import 'card.dart';

class PaginatedList extends StatefulWidget {
  @override
  _PaginatedListState createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  ///Api service to fetch data
  final ApiService apiService = ApiService(baseUrl: 'https://dummyjson.com/users');
  ///list to store data fetched
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
  /// Fetch data from API based on current page and limit

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
/// Go to a specific page and refresh the data

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
      _data.clear();
    });
    _fetchData();
  }
/// Build pagination buttons for navigation
  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];
    int pagesToShow = _showAllPages ? _totalPages : 5;

    for (int i = 1; i <= pagesToShow; i++) {
      buttons.add(
        ElevatedButton(
          onPressed: _currentPage == i ? null : () => _goToPage(i),
          child: Text('$i'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            textStyle: TextStyle(fontSize: 12),
            minimumSize: Size(30, 30),
          ),
        ),
      );
    }

/// Show "Show More" button if there are more pages to display

    if (!_showAllPages && _totalPages > 5) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showAllPages = true;
            });
          },
          child: Icon(Icons.arrow_forward),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(30, 30),
          ),
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7fcfbc),
      appBar: AppBar(
        backgroundColor: AppColors.appbar,
        title: Center(
          child: Text(
            'Users List',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
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
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "ADMIN",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout_sharp),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 15,
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
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageButtons(),
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

