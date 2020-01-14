import 'package:flutter/material.dart';
import 'package:uni_discente/ui/noticias.ui.dart';


class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _currentIndex = 0;
  String _title;
  final List<Widget> _children = [
    NoticiasPage(),
    Center(child: Text("Página 2")),
    Center(child: Text("Página 3")),
    Center(child: Text("Página 4")),
  ];
  PageController pageController = PageController();
  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Notícias';
          }
          break;
        case 1:
          {
            _title = 'Página 2';
          }
          break;
        case 2:
          {
            _title = 'Página 3';
          }
          break;
        case 3:
          {
            _title = 'Página 4';
          }
          break;
      }
    });
  }

  Widget _bottomNavigationBar(int currentIndex, Function onTap) =>
      BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.web),
            title: Text('Notícias'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.filter_2),
            title: Text('Página 2'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.filter_3),
            title: Text('Página 3'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.filter_4), title: Text('Página 4'))
        ],
      );
  @override
  void initState() {
    _title = "Notícias";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          elevation: 1.0,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _children,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar:
            _bottomNavigationBar(_currentIndex, _onItemTapped));
  }
}
