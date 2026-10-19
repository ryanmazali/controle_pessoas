// Importa o pacote Material do Flutter, que traz os widgets prontos (botões, textos, AppBar etc.)
import 'package:flutter/material.dart';

// main() é a primeira função que roda quando o app abre (ponto de entrada do programa)
void main() {
  // runApp recebe o widget principal e desenha ele na tela; const porque MeuApp nunca muda
  runApp(const MeuApp());
}

// Classe principal do app; é StatelessWidget porque ela mesma não guarda nenhum dado que muda
class MeuApp extends StatelessWidget {
  // Construtor const; super.key repassa a key opcional para a classe pai (StatelessWidget)
  const MeuApp({super.key});

  // @override indica que estamos reescrevendo o método build que veio da classe pai
  @override
  // build monta e devolve o widget que vai aparecer na tela; context diz onde ele está na árvore
  Widget build(BuildContext context) {
    // MaterialApp configura o app no estilo Material; const porque nada aqui dentro muda
    return const MaterialApp(
      // Esconde a faixa vermelha "DEBUG" que aparece no canto da tela
      debugShowCheckedModeBanner: false,
      // home é a primeira tela que o app mostra
      home: TelaContador(),
    );
  }
}

// Tela do contador; é StatefulWidget porque os valores (contador, mensagem) mudam com o uso
class TelaContador extends StatefulWidget {
  // Construtor const da tela, também repassando a key para a classe pai
  const TelaContador({super.key});

  // Reescreve o método da classe pai que cria o objeto State
  @override
  // createState cria o objeto que guarda os dados da tela; => é forma curta de "return"
  State<TelaContador> createState() => _TelaContadorState();
}

// Classe que guarda o estado da tela; o _ deixa ela privada (só usada neste arquivo)
// State<TelaContador> usa generics para dizer que este estado pertence à TelaContador
class _TelaContadorState extends State<TelaContador> {
  // Quantidade de pessoas no ambiente agora; começa em 0
  int contador = 0;
  // Número máximo de pessoas permitido; começa em 10
  int capacidade = 10;
  // Texto de aviso mostrado na tela; começa vazio (sem aviso)
  String mensagem = '';
  // Controlador que lê o texto digitado no TextField; final porque o objeto não é trocado depois
  final TextEditingController controlador = TextEditingController();

  // Regra de negócio: não passa da capacidade máxima
  // void porque a função só executa uma ação e não devolve nenhum valor
  void incrementar() {
    // Só deixa entrar se ainda houver espaço
    if (contador < capacidade) {
      // setState avisa o Flutter que os dados mudaram e que ele deve chamar o build de novo
      setState(() {
        // Soma 1 ao contador
        contador++;
        // Limpa qualquer aviso antigo
        mensagem = '';
      });
    } else {
      // Se já está cheio, não soma e mostra o aviso (setState para o texto aparecer na tela)
      setState(() {
        // Mensagem de erro exibida em vermelho
        mensagem = 'Capacidade máxima atingida!';
      });
    }
  }

  // Regra de negócio: não permite valor negativo
  // Também é void: só altera o estado, não retorna nada
  void decrementar() {
    // Só deixa sair se tiver pelo menos uma pessoa
    if (contador > 0) {
      // setState para a tela ser redesenhada com o novo valor
      setState(() {
        // Subtrai 1 do contador
        contador--;
        // Limpa qualquer aviso antigo
        mensagem = '';
      });
    } else {
      // Se já está em 0, não subtrai e mostra o aviso
      setState(() {
        // Mensagem de erro exibida em vermelho
        mensagem = 'O ambiente já está vazio!';
      });
    }
  }

  // Lê o valor digitado pelo usuário e define a capacidade
  void definirCapacidade() {
    // tryParse tenta converter o texto em int; se não for número devolve null, por isso int? (pode ser nulo)
    int? valor = int.tryParse(controlador.text);

    // || é "OU": entra aqui se o valor for nulo (texto inválido/vazio) ou se for zero/negativo
    if (valor == null || valor <= 0) {
      // Mostra o aviso de valor inválido
      setState(() {
        // Mensagem de erro para o usuário
        mensagem = 'Digite um número válido!';
      });
      // Se o valor é válido mas menor que as pessoas que já estão dentro, não aceita
    } else if (valor < contador) {
      // Mostra o aviso de capacidade pequena demais
      setState(() {
        // Mensagem de erro para o usuário
        mensagem = 'Capacidade menor que o número de pessoas!';
      });
      // Se passou nas validações, o valor é aceito
    } else {
      // setState para a nova capacidade aparecer na tela
      setState(() {
        // Aqui o Dart já sabe que valor não é null (foi testado acima), então pode ir para um int
        capacidade = valor;
        // Limpa qualquer aviso antigo
        mensagem = '';
      });
      // Apaga o texto do campo depois de salvar
      controlador.clear();
    }
  }

  // Reescreve o build da classe State; ele roda de novo toda vez que o setState é chamado
  @override
  // Monta toda a interface da tela usando os valores atuais das variáveis
  Widget build(BuildContext context) {
    // Scaffold é a estrutura básica de uma tela (barra no topo + corpo)
    return Scaffold(
      // AppBar é a barra do topo com o título; Text é const porque o título nunca muda
      appBar: AppBar(title: const Text('Controle de Pessoas')),
      // body é o conteúdo principal; Padding dá um espaço interno em volta
      body: Padding(
        // EdgeInsets.all(20) coloca 20 pixels de espaço em todos os lados
        padding: const EdgeInsets.all(20),
        // child recebe UM widget só; aqui é uma Column
        child: Column(
          // Centraliza os itens na vertical (eixo principal da Column)
          mainAxisAlignment: MainAxisAlignment.center,
          // children recebe uma LISTA de widgets, mostrados um embaixo do outro
          children: [
            // Mostra o número de pessoas; não é const porque o valor muda
            Text(
              // Interpolação: $contador coloca o valor da variável dentro da String
              '$contador',
              // Estilo do texto: fonte grande e em negrito; const porque o estilo não muda
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            // Mostra a capacidade atual usando interpolação de string
            Text('Capacidade máxima: $capacidade',
                // Tamanho da fonte 18; const porque é fixo
                style: const TextStyle(fontSize: 18)),
            // Caixa vazia usada só para dar espaço vertical de 10 pixels
            const SizedBox(height: 10),
            // Texto de status do ambiente
            Text(
              // Operador ternário: condição ? valor se verdadeiro : valor se falso
              contador >= capacidade ? 'LOTADO' : 'Disponível',
              // Sem const aqui porque a cor depende do contador (muda em tempo de execução)
              style: TextStyle(
                // Tamanho da fonte do status
                fontSize: 20,
                // Ternário de novo: vermelho se lotado, verde se ainda tem vaga
                color: contador >= capacidade ? Colors.red : Colors.green,
              ),
            ),
            // Espaço vertical de 10 pixels
            const SizedBox(height: 10),
            // Mostra a mensagem de aviso em vermelho (fica invisível quando está vazia)
            Text(mensagem, style: const TextStyle(color: Colors.red)),
            // Espaço vertical de 20 pixels
            const SizedBox(height: 20),
            // Row coloca os widgets lado a lado (na horizontal)
            Row(
              // Centraliza os botões na horizontal (eixo principal da Row)
              mainAxisAlignment: MainAxisAlignment.center,
              // Lista de widgets da linha
              children: [
                // Botão de saída de pessoa
                ElevatedButton(
                  // Passa a função sem () para ela rodar só no clique, e não na hora do build
                  onPressed: decrementar,
                  // Texto do botão; const porque é fixo
                  child: const Text('Saída (-)'),
                ),
                // Espaço horizontal de 20 pixels entre os botões
                const SizedBox(width: 20),
                // Botão de entrada de pessoa
                ElevatedButton(
                  // Callback: o Flutter chama incrementar quando o botão for apertado
                  onPressed: incrementar,
                  // Texto do botão
                  child: const Text('Entrada (+)'),
                ),
              ],
            ),
            // Espaço vertical de 40 pixels antes do campo de texto
            const SizedBox(height: 40),
            // Campo onde o usuário digita a nova capacidade
            TextField(
              // Liga o campo ao controlador, para conseguir ler o texto com controlador.text
              controller: controlador,
              // Abre o teclado numérico no celular
              keyboardType: TextInputType.number,
              // Aparência do campo; const porque não muda
              decoration: const InputDecoration(
                // Texto de rótulo que aparece dentro/acima do campo
                labelText: 'Nova capacidade máxima',
                // Borda em volta do campo
                border: OutlineInputBorder(),
              ),
            ),
            // Espaço vertical de 10 pixels
            const SizedBox(height: 10),
            // Botão que confirma a nova capacidade
            ElevatedButton(
              // Chama definirCapacidade quando o botão for clicado (sem parênteses)
              onPressed: definirCapacidade,
              // Texto do botão
              child: const Text('Definir capacidade'),
            ),
          ],
        ),
      ),
    );
  }
}
