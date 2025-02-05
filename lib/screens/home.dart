import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: CryptogramGameHome(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}

class CryptogramGameHome extends StatefulWidget {
  @override
  _CryptogramGameHomeState createState() => _CryptogramGameHomeState();
}

class _CryptogramGameHomeState extends State<CryptogramGameHome> {
  final List<String> phrases = [
    "HELLO FLUTTER",
    "WELCOME TO THE GAME",
    "HAVE FUN CODING"
  ];

  String phrase = "HELLO FLUTTER";
  String encryptedPhrase = "";
  final Map<int, String> guessedLetters = {};
  final Map<String, String> encryptionMap = {};
  final Map<int, FocusNode> focusNodes = {}; // FocusNode for each TextField
  int? focusedIndex; // Track the currently focused TextField index

  @override
  void initState() {
    super.initState();
    encryptPhrase();
  }

  void changePhrase(int index) {
    setState(() {
      phrase = phrases[index];
      guessedLetters.clear();
      encryptPhrase();
    });
  }

  void encryptPhrase() {
    encryptionMap.clear();
    encryptedPhrase = "";
    Random random = Random();
    List<String> alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
    List<String> shuffledAlphabet = List.from(alphabet)..shuffle(random);

    for (int i = 0; i < phrase.length; i++) {
      String char = phrase[i];
      if (char == ' ') {
        encryptedPhrase += ' ';
      } else {
        if (!encryptionMap.containsKey(char)) {
          encryptionMap[char] = shuffledAlphabet.removeAt(0);
        }
        encryptedPhrase += encryptionMap[char]!;
      }
    }
  }

  bool _isDuplicateWithDifferentEncryption(int index, Map<int, String> guessedLetters) {
    String? currentValue = guessedLetters[index];
    if (currentValue == null || currentValue.isEmpty) {
      return false; // No value, no duplication
    }

    // Check for the same letter mapped to different encryptions
    for (int i = 0; i < phrase.length; i++) {
      if (i != index &&
          guessedLetters[i] == currentValue && // Same guessed letter
          encryptedPhrase[i] != encryptedPhrase[index]) { // Different encryption
        return true;
      }
    }
    return false;
  }

  void _onKeyPressed(String letter) {
    if (focusedIndex != null) {
      setState(() {
        // Get the encrypted character at the focused index
        String encryptedChar = encryptedPhrase[focusedIndex!];

        // Update all TextFields with the same encrypted character
        for (int i = 0; i < encryptedPhrase.length; i++) {
          if (encryptedPhrase[i] == encryptedChar) {
            guessedLetters[i] = letter;
          }
        }

        // Find the next empty text field with the same encryption
        int nextIndex = -1;
        for (int i = 0; i < encryptedPhrase.length; i++) {
          if (encryptedPhrase[i] == encryptedChar && (guessedLetters[i] == null || guessedLetters[i]!.isEmpty)) {
            nextIndex = i;
            break;
          }
        }

        // If no empty text field with the same encryption is found, find the next empty text field
        if (nextIndex == -1) {
          for (int i = 0; i < encryptedPhrase.length; i++) {
            if (encryptedPhrase[i] != ' ' && (guessedLetters[i] == null || guessedLetters[i]!.isEmpty)) {
              nextIndex = i;
              break;
            }
          }
        }

        // Move focus to the next empty text field
        if (nextIndex != -1) {
          focusNodes[nextIndex]?.requestFocus();
          focusedIndex = nextIndex;
        } else {
          // If no empty text field is found, unfocus the current one
          focusNodes[focusedIndex!]?.unfocus();
          focusedIndex = null;

          // Check if the solution is correct
          _checkSolution(context, phrase, guessedLetters);
        }
      });
    }
  }

  void _onDeletePressed() {
    if (focusedIndex != null) {
      setState(() {
        // Get the encrypted character at the focused index
        String encryptedChar = encryptedPhrase[focusedIndex!];

        // Delete the letter from all TextFields with the same encrypted character
        for (int i = 0; i < encryptedPhrase.length; i++) {
          if (encryptedPhrase[i] == encryptedChar) {
            guessedLetters.remove(i);
          }
        }

        focusNodes[focusedIndex!]?.unfocus(); // Unfocus after deleting
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptogram Game'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Select a Phrase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Add phrase selection buttons to the drawer
            ...phrases.asMap().entries.map((entry) {
              int index = entry.key;
              String phrase = entry.value;
              return ListTile(
                title: Text('Phrase ${index + 1}'),
                onTap: () {
                  changePhrase(index); // Change the phrase
                  Navigator.pop(context); // Close the drawer
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the cryptogram
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final List<Widget> lines = [];
                double currentWidth = 0;
                List<Widget> currentLine = [];

                for (int i = 0; i < encryptedPhrase.length;) {
                  String word = "";
                  int startIndex = i;

                  while (i < encryptedPhrase.length && encryptedPhrase[i] != ' ') {
                    word += encryptedPhrase[i];
                    i++;
                  }

                  if (i < encryptedPhrase.length && encryptedPhrase[i] == ' ') {
                    word += ' ';
                    i++;
                  }

                  double wordWidth = word.length * 32;

                  if (currentWidth + wordWidth > maxWidth) {
                    lines.add(Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: currentLine,
                    ));
                    currentLine = [];
                    currentWidth = 0;
                  }

                  for (int j = 0; j < word.length; j++) {
                    String char = word[j];

                    if (char == ' ') {
                      currentWidth += 20;
                      currentLine.add(const SizedBox(width: 20));
                    } else {
                      currentWidth += 32;
                      int index = startIndex + j;
                      focusNodes[index] ??= FocusNode(); // Initialize FocusNode if not exists

                      Widget charWidget = Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: TextField(
                                focusNode: focusNodes[index],
                                controller: TextEditingController(
                                  text: guessedLetters[index] ?? '',
                                ),
                                readOnly: true, // Prevent default keyboard from opening
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                onTap: () {
                                  setState(() {
                                    focusedIndex = index; // Track the focused TextField
                                    // Highlight all TextFields with the same encryption
                                    String encryptedChar = encryptedPhrase[index];
                                    for (int i = 0; i < encryptedPhrase.length; i++) {
                                      if (encryptedPhrase[i] == encryptedChar) {
                                        focusNodes[i]?.requestFocus();
                                      }
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  counterText: '',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: (focusedIndex != null && encryptedPhrase[index] == encryptedPhrase[focusedIndex!])
                                          ? Colors.deepOrangeAccent // Highlight color
                                          : Colors.black, // Default color
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2), // Light blue when focused
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 2),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isDuplicateWithDifferentEncryption(index, guessedLetters)
                                      ? Colors.red // Red if duplicate with different encryption
                                      : Colors.black, // Black otherwise
                                ),
                              ),
                            ),
                          ),
                          Text(
                            char,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                      currentLine.add(charWidget);
                    }
                  }
                }

                if (currentLine.isNotEmpty) {
                  lines.add(Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: currentLine,
                  ));
                }

                return Column(
                  children: lines,
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Custom Keyboard with Turkish characters and delete button
          CustomKeyboard(
            onKeyPressed: _onKeyPressed,
            onDeletePressed: _onDeletePressed,
          ),
        ],
      ),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDeletePressed;

  const CustomKeyboard({
    Key? key,
    required this.onKeyPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          ...['A', 'B', 'C', 'Ç', 'D', 'E', 'F', 'G']
              .map((letter) => _buildKey(letter))
              .toList(),
          ...['Ğ', 'H', 'I', 'İ', 'J', 'K', 'L', 'M']
              .map((letter) => _buildKey(letter))
              .toList(),
          ...['N', 'O', 'Ö', 'P', 'Q', 'R', 'S', 'Ş']
              .map((letter) => _buildKey(letter))
              .toList(),
          ...['T', 'U', 'Ü', 'V', 'W', 'X', 'Y', 'Z']
              .map((letter) => _buildKey(letter))
              .toList(),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildKey(String letter) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: ElevatedButton(
        onPressed: () => onKeyPressed(letter),
        child: Text(
          letter,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: 96.0,
      height: 48.0,
      child: ElevatedButton(
        onPressed: onDeletePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent[100],
        ),
        child: const Icon(
          Icons.backspace,
          color: Colors.white,
        ),
      ),
    );
  }
}

void _checkSolution(context, phrase, guessedLetters) {
  bool isCorrect = true;

  for (int i = 0; i < phrase.length; i++) {
    if (phrase[i] != ' ') {
      if (guessedLetters[i] == null || guessedLetters[i]!.isEmpty || guessedLetters[i] != phrase[i]) {
        isCorrect = false;
        break;
      }
    }
  }

  // Show a dialog or snackbar with the result
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(isCorrect ? "Correct! 🎉" : "Wrong! Try again. ❌"),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
    ),
  );
}