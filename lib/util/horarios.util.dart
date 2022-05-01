class HorariosUtil {
  static final _diasDaSemana = {
    '2': 'Segunda-feira',
    '3': 'Terça-feira',
    '4': 'Quarta-feira',
    '5': 'Quinta-feira',
    '6': 'Sexta-feira',
    '7': 'Sábado'
  };

  static final _turnoHorarios = {
    'M': {
      '1': {'08:00', '09:00'},
      '2': {'09:00', '10:00'},
      '3': {'10:00', '11:00'},
      '4': {'11:00', '12:00'},
    },
    'T': {
      '1': {'14:00', '15:00'},
      '2': {'15:00', '16:00'},
      '3': {'16:00', '17:00'},
      '4': {'17:00', '18:00'},
    },
    'N': {
      '1': {'18:00', '19:00'},
      '2': {'19:00', '20:00'},
      '3': {'20:00', '21:00'},
      '4': {'21:00', '22:00'},
    },
  };

  static final _regex = RegExp(r'(([2-7]{1,6})([M|T|N])([1-4]{1,7}))');

  static String parse(String codigo) {
    String result = '';
    if (_regex.hasMatch(codigo)) {
      final matches = _regex.allMatches(codigo);
      var matchesList = matches.toList();
      final ids = <dynamic>{};
      matchesList.retainWhere((x) => ids.add(x.group(0)));
      matchesList.asMap().forEach((i, match) {
        result += _parseMatch(match);
        if (i + 1 != matchesList.length) {
          result += ' & ';
        }
      });
      if (result.isNotEmpty) {
        result += '.';
      }
    }
    return result;
  }

  static String _parseMatch(RegExpMatch? match) {
    String result = '';
    if (match != null) {
      String dias = match.group(2) ?? '';
      String turno = match.group(3) ?? '';
      String horarios = match.group(4) ?? '';

      var listDias = _convertStringToListString(dias);
      var listHorarios = _convertStringToListString(horarios);
      listHorarios.sort();

      for (var dia in listDias) {
        result += '${_diasDaSemana[dia]}';
        if (listDias.length > 1) {
          if (listDias.last != dia) {
            if (listDias[listDias.length - 2] == dia) {
              result += ' e ';
            } else {
              result += ', ';
            }
          }
        }
      }
      result +=
          ' de ${_turnoHorarios[turno]?[listHorarios.first]?.first} às ${_turnoHorarios[turno]?[listHorarios.last]?.last}';
    }
    return result;
  }

  static List<String> _convertStringToListString(String value) {
    List<String> result = [];
    for (int i = 0; i < value.length; i++) {
      result.add(value[i]);
    }
    return result;
  }
}
