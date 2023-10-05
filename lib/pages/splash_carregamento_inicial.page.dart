import 'package:flutter/material.dart';

import '../blocs/carregamento.bloc.dart';
import '../blocs/login.bloc.dart';
import 'inicio.page.dart';
import 'login_page.dart';

class SplashCarregamentoInicialPage extends StatefulWidget {
  const SplashCarregamentoInicialPage({Key? key}) : super(key: key);

  @override
  State<SplashCarregamentoInicialPage> createState() =>
      _SplashCarregamentoInicialPageState();
}

class _SplashCarregamentoInicialPageState
    extends State<SplashCarregamentoInicialPage> {
  late CarregamentoBloc carregamentoBloc;
  @override
  void initState() {
    super.initState();
    carregamentoBloc = CarregamentoBloc()..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D294D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'icon_book',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 45.0,
                child: Image.asset('assets/icon_init.png'),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            StreamBuilder<Object>(
                stream: carregamentoBloc.carregamentoStream,
                builder: (context, snapshot) {
                  print(carregamentoBloc.carregamentoState);
                  switch (carregamentoBloc.carregamentoState) {
                    case CarregamentoState.loadingProfile:
                      return Column(
                        children: const [
                          Text(
                            'Obtendo seu perfil...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );

                    case CarregamentoState.initial:
                      return Column(
                        children: const [
                          Text(
                            'Obtendo seus dados...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    case CarregamentoState.loadingClasses:
                      return Column(
                        children: const [
                          Text(
                            'Obtendo suas turmas...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    case CarregamentoState.loadingCalendar:
                      return Column(
                        children: const [
                          Text(
                            'Obtendo seu calendário de turmas...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    case CarregamentoState.loadingTasks:
                      return Column(
                        children: const [
                          Text(
                            'Obtendo suas tarefas...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    case CarregamentoState.ready:
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InicioPage()),
                              ));
                      return Column(
                        children: const [
                          Text(
                            'Inicializando...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    case CarregamentoState.error:
                      return Column(
                        children: <Widget>[
                          const Text(
                            'Tentar novamente',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              carregamentoBloc.load();
                            },
                            icon:
                                const Icon(Icons.refresh, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () async {
                                await LoginBloc().deslogar();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const LoginPageN()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const Text('Sair',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)))
                        ],
                      );
                    case CarregamentoState.loadingChats:
                      return Column(
                        children: const [
                          Text(
                            'Obtendo suas conversas...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
