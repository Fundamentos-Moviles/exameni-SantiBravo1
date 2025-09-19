import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int gridSize = 6;
  late List<List<bool>> grid;
  late List<List<bool>> revealed; // Matriz para trackear celdas reveladas
  late int bombRow;
  late int bombCol;
  bool gameOver = false;
  bool gameWon = false;
  int revealedCount = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    grid = List.generate(
      gridSize,
          (i) => List.generate(gridSize, (j) => false),
    );

    revealed = List.generate( // Inicializar matriz de celdas reveladas
      gridSize,
          (i) => List.generate(gridSize, (j) => false),
    );

    bombRow = Random().nextInt(gridSize);
    bombCol = Random().nextInt(gridSize);
    grid[bombRow][bombCol] = true;

    gameOver = false;
    gameWon = false;
    revealedCount = 0;
  }

  void revealCell(int row, int col) {
    if (gameOver || revealed[row][col]) return; // No revelar si ya está revelada

    setState(() {
      revealed[row][col] = true; // Marcar como revelada

      if (grid[row][col]) {
        // Es la bomba
        gameOver = true;
      } else {
        // No es bomba
        revealedCount++;

        // Verificar si ganó (todas las celdas no bombas reveladas)
        if (revealedCount == (gridSize * gridSize) - 1) {
          gameWon = true;
          gameOver = true;
        }
      }
    });
  }

  void restartGame() {
    setState(() {
      initializeGame();
    });
  }

  Color getCellColor(int row, int col) {
    if (!revealed[row][col] && !gameOver) {
      return Colors.grey; // Estado inactivo (no revelado)
    } else if (grid[row][col]) {
      return Colors.red; // Bomba
    } else {
      return Colors.green; // Celda segura (revelada)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscaminas Santiago Bravo Alcalá'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Información del juego
          if (gameOver)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                gameWon ? '¡Ganaste!' : '¡Game Over!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Celdas reveladas: $revealedCount/${(gridSize * gridSize) - 1}',
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Grid usando List.generate con Expanded
          Expanded(
            child: Column(
              children: List.generate(
                gridSize,
                    (row) => Expanded(
                  child: Row(
                    children: List.generate(
                      gridSize,
                          (col) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () => revealCell(row, col),
                            child: Container(
                              decoration: BoxDecoration(
                                color: getCellColor(row, col),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botón de reinicio
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: restartGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text('Reiniciar Juego'),
            ),
          ),
        ],
      ),
    );
  }
}