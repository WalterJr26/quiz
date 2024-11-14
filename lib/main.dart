import 'dart:async'; // Importa o Timer
import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timer = 30; 
  late Timer _timerController; // O controlador do cronômetro

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Qual o ano de fundação da Libertadores?',
      'options': ['1958', '1955', '1960', '1959'],
      'imagem': 'lib/assets/liberta.png',
      'answer': 2,
    },
    {
      'question': 'Qual é o clube com mais títulos?',
      'options': ['River Plate', 'São Paulo', 'Independiente', 'Flamengo'],
      'imagem': 'lib/assets/troféu.png',
      'answer': 2,
    },
    {
      'question': 'Quem é o maior artilheiro da competição?',
      'options': ['Alberto Spencer', 'Fernando Morena', 'Lucas Pratto', 'Gabigol'],
      'imagem': 'lib/assets/artilheiro.png',
      'answer': 0,
    },
    {
      'question': 'Qual o País com mais titulos?',
      'options': ['Uruguai', 'Argentina', 'Brasil', 'Colombia'],
      'imagem': 'lib/assets/mapa.png',
      'answer': 1,
    },
     {
      'question': 'Qual clube africano já participou da Libertadores?',
      'options': ['Al Ahly', 'Mazembe', 'Raja Casablanca', 'Zamalek'],
      'imagem': 'lib/assets/africa.png',
      'answer': 1,
    },
     {
      'question': 'Quem é o maior artilheiro Brasileiro da competição?',
      'options': ['Fred', 'Rony', 'Gabigol', 'Luizão'],
      'imagem': 'lib/assets/artbr.png',
      'answer': 2,
    },
     {
      'question': 'Qual o clube paraguaio já foi campeão?',
      'options': ['Olimpia', 'Libertad', 'Cerro Porteño', 'Tacuary'],
      'imagem': 'lib/assets/paraguai.png',
      'answer': 0,
    },
     {
      'question': 'Qual  foi o país europeu que já sediou a final?',
      'options': ['Itália', 'Espanha', 'França', 'Inglaterra'],
      'imagem': 'lib/assets/europa.png',
      'answer': 1,
    },
     {
      'question': 'Qual o primeiro clube brasileiro a ser campeão?',
      'options': ['Santos', 'Flamengo', 'São Paulo', 'Vasco'],
      'imagem': 'lib/assets/brcamp.png',
      'answer': 0,
    },
     {
      'question': 'Qual desses clubes nunca foi campeão?',
      'options': ['Atletico Nacional', 'Vasco', 'LDU', 'Cerro Porteño'],
      'imagem': 'lib/assets/x.png',
      'answer': 3,
    },
     {
      'question': 'Qual clube tem a maior sequencia de titulos?',
      'options': ['Independiente', 'Peñarol', 'Santos', 'Boca Juniors'],
      'imagem': 'lib/assets/pilha.png',
      'answer': 0,
    },  
  ];

  @override
  void initState() {
    super.initState();
    _startTimer(); 
  }

  @override
  void dispose() {
    _timerController.cancel(); 
    super.dispose();
  }

  void _startTimer() {
    _timerController = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
      } else {
        
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timer = 30; 
      });
      _startTimer(); 
    } else {
      _showScoreDialog(); // Mostra a pontuação final
    }
  }

  void _answerQuestion(int selectedOption) {
    if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score++;
    }
    _nextQuestion();
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Quiz Concluído!'),
        content: Text('Você acertou $_score de ${_questions.length} perguntas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetQuiz();
            },
            child: Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _score = 0;
      _currentQuestionIndex = 0;
      _timer = 30; // Reinicia o cronômetro
    });
    _startTimer(); // Reinicia o cronômetro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: _currentQuestionIndex < _questions.length
          ? _buildQuizQuestion()
          : Center(
              child: Text(
                'Parabéns! Você completou o quiz.',
                style: TextStyle(fontSize: 24),
              ),
            ),
    );
  }

  Widget _buildQuizQuestion() {
    final question = _questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pergunta ${_currentQuestionIndex + 1} de ${_questions.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          
          Text(
            'Tempo: $_timer s',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
          SizedBox(height: 20),

          Image.asset(question['imagem'], height: 200, fit: BoxFit.cover),
          SizedBox(height: 20),

          Text(
            question['question'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Botões de resposta
          ...List.generate(question['options'].length, (index) {
            return ElevatedButton(
              onPressed: () => _answerQuestion(index),
              child: Text(question['options'][index]),
            );
          }),
        ],
      ),
    );
  }
}
 
