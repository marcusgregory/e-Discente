import 'package:decimal/decimal.dart';

class SaldoUtils {
  static int refeicoesRestantes(String saldo) {
    String valorString = saldo; // Valor total em formato de string
    Decimal valorTotal = Decimal.parse(
        valorString.replaceAll(',', '.')); // Converte a string para Decimal

    Decimal valorRefeicao = Decimal.parse('1.10');
    // Valor de cada refeição

    int numeroRefeicoes = (valorTotal / valorRefeicao).toBigInt().toInt();
    return numeroRefeicoes;
  }

  static String textoRefeicoes(int numRefeicoes) {
    if (numRefeicoes <= 0) {
      return 'Você não tem refeições restantes 😭';
    }
    var texto = 'Você tem';
    if (numRefeicoes == 1) {
      return '$texto $numRefeicoes refeição restante 😨';
    } else {
      return '$texto $numRefeicoes refeições restantes 😋';
    }
  }
}
