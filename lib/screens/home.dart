import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kriptogram/screens/settings.dart'; // For custom fonts

class CryptogramGameHome extends StatefulWidget {
  @override
  _CryptogramGameHomeState createState() => _CryptogramGameHomeState();
}

class _CryptogramGameHomeState extends State<CryptogramGameHome> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  List<String> phrases = [];

  String phrase = "";
  String encryptedPhrase = "";
  final Map<int, String> guessedLetters = {};
  final Map<String, String> encryptionMap = {};
  final Map<int, FocusNode> focusNodes = {};
  int? focusedIndex;

  Set<String> usedLetters = {};
  Set<int> revealedLetters = {};

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPhrases();
  }

  @override
  void dispose() {
    for (var node in focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _fetchPhrases() async {
    try {
      DatabaseEvent snapshot = await _databaseRef.child('phrases').once();
      Map<dynamic, dynamic>? values =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      setState(() {
        if (values != null) {
          phrases = values.values.cast<String>().toList();
          if (phrases.isNotEmpty) {
            phrase = phrases[0];
            encryptPhrase();

            _setFocusToFirstEmptyField();
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load phrases. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _setFocusToFirstEmptyField() {
    for (int i = 0; i < encryptedPhrase.length; i++) {
      if (encryptedPhrase[i] != ' ' &&
          (guessedLetters[i] == null || guessedLetters[i]!.isEmpty)) {
        focusNodes[i] = FocusNode();
        focusNodes[i]?.requestFocus();
        focusedIndex = i;
        break;
      }
    }
  }

  void changePhrase(int index) {
    setState(() {
      phrase = phrases[index];
      guessedLetters.clear();
      usedLetters.clear();
      revealedLetters.clear();
      encryptPhrase();

      // Find the first empty field and set focus
      for (int i = 0; i < encryptedPhrase.length; i++) {
        if (encryptedPhrase[i] != ' ' &&
            (guessedLetters[i] == null || guessedLetters[i]!.isEmpty)) {
          focusNodes[i]?.requestFocus();
          focusedIndex = i;
          break;
        }
      }
    });
  }

  String toTurkishUpperCase(String input) {
    final Map<String, String> turkishUpperMap = {
      'i': 'İ',
      'ı': 'I',
      'ğ': 'Ğ',
      'ü': 'Ü',
      'ş': 'Ş',
      'ö': 'Ö',
      'ç': 'Ç',
    };

    return input.split('').map((char) => turkishUpperMap[char] ?? char.toUpperCase()).join();
  }

  void encryptPhrase() {
    encryptionMap.clear();
    encryptedPhrase = "";
    guessedLetters.clear();
    focusNodes.clear();
    revealedLetters.clear(); // Clear revealed letters

    Random random = Random();
    List<String> alphabet = "ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ".split("");
    List<String> shuffledAlphabet = List.from(alphabet)..shuffle(random);

    // Determine the number of letters to reveal
    int revealCount = 0;
    if (phrase.length <= 10) {
      revealCount = 1;
    } else if (phrase.length <= 25) {
      revealCount = 2;
    } else {
      revealCount = 3;
    }

    // Collect unique non-space letters in the phrase
    Set<String> uniqueChars =
        phrase.toLowerCase().split("").where((char) => char != ' ').toSet();

    List<String> revealChars = uniqueChars.toList()..shuffle();
    revealChars =
        revealChars.take(revealCount).toList(); // Select letters to reveal

    // Encrypt the phrase
    for (int i = 0; i < phrase.length; i++) {
      String char = phrase[i]
          .toLowerCase(); // Convert to lowercase for case-insensitive encryption

      if (char == ' ') {
        encryptedPhrase += ' '; // Preserve spaces
      } else {
        if (!encryptionMap.containsKey(char)) {
          encryptionMap[char] =
              shuffledAlphabet.removeAt(0); // Assign a unique encrypted letter
        }

        if (revealChars.contains(char)) {
          guessedLetters[i] = toTurkishUpperCase(phrase[i]); // Add revealed letter as uppercase
          revealedLetters.add(i); // Mark this index as revealed
          usedLetters.add(toTurkishUpperCase(phrase[i]));

          encryptedPhrase +=
              '*'; // Set encryption of revealed letter to a space
        } else {
          encryptedPhrase +=
              encryptionMap[char]!; // Append the encrypted letter
        }
      }
    }

    setState(() {
      encryptedPhrase = encryptedPhrase;
    });
  }

  bool _isDuplicateWithDifferentEncryption(
      int index, Map<int, String> guessedLetters) {
    String? currentValue = guessedLetters[index];
    if (currentValue == null || currentValue.isEmpty) {
      return false;
    }

    for (int i = 0; i < phrase.length; i++) {
      if (i != index &&
          guessedLetters[i] == currentValue &&
          encryptedPhrase[i] != encryptedPhrase[index]) {
        return true;
      }
    }
    return false;
  }

  void _onKeyPressed(String letter) {
    if (focusedIndex != null) {
      setState(() {
        String encryptedChar = encryptedPhrase[focusedIndex!];

        for (int i = 0; i < encryptedPhrase.length; i++) {
          if (encryptedPhrase[i] == encryptedChar) {
            guessedLetters[i] = letter;
          }
        }

        usedLetters.add(letter);

        int nextIndex = -1;
        for (int i = 0; i < encryptedPhrase.length; i++) {
          if (encryptedPhrase[i] == encryptedChar &&
              (guessedLetters[i] == null || guessedLetters[i]!.isEmpty)) {
            nextIndex = i;
            break;
          }
        }

        if (nextIndex == -1) {
          for (int i = 0; i < encryptedPhrase.length; i++) {
            if (encryptedPhrase[i] != ' ' &&
                (guessedLetters[i] == null || guessedLetters[i]!.isEmpty)) {
              nextIndex = i;
              break;
            }
          }
        }

        if (nextIndex != -1) {
          focusNodes[nextIndex]?.requestFocus();
          focusedIndex = nextIndex;
        } else {
          focusNodes[focusedIndex!]?.unfocus();
          focusedIndex = null;
          _checkSolution(context, phrase, guessedLetters);
        }
      });
    }
  }

  void _onDeletePressed() {
    if (focusedIndex != null) {
      setState(() {
        String encryptedChar = encryptedPhrase[focusedIndex!];

        for (int i = 0; i < encryptedPhrase.length; i++) {
          if (encryptedPhrase[i] == encryptedChar) {
            String? removedLetter = guessedLetters.remove(i);
            if (removedLetter != null) {
              usedLetters.remove(removedLetter); // Remove deleted letter from usedLetters
            }
          }
        }

        focusNodes[focusedIndex!]?.unfocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Kriptogram',
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Text(
                  'Cümle Seçin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...phrases.asMap().entries.map((entry) {
                int index = entry.key;
                String phrase = entry.value;
                return ListTile(
                  title: Text(
                    'Cümle ${index + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onTap: () {
                    changePhrase(index);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Cryptogram Display
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.075,
                left: screenWidth * 0.01,
                right: screenWidth * 0.01,
                bottom: screenHeight * 0.1,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth;
                      final List<Widget> lines = [];
                      double currentWidth = 0;
                      List<Widget> currentLine = [];

                      for (int i = 0; i < encryptedPhrase.length;) {
                        String word = "";
                        int startIndex = i;

                        while (i < encryptedPhrase.length &&
                            encryptedPhrase[i] != ' ') {
                          word += encryptedPhrase[i];
                          i++;
                        }

                        if (i < encryptedPhrase.length &&
                            encryptedPhrase[i] == ' ') {
                          word += ' ';
                          i++;
                        }

                        double wordWidth = word.length * (screenWidth * 0.07);

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
                            currentWidth += screenWidth * 0.04;
                            currentLine
                                .add(SizedBox(width: screenWidth * 0.04));
                          } else {
                            currentWidth += screenWidth * 0.05;
                            int index = startIndex + j;
                            focusNodes[index] ??= FocusNode();

                            Widget charWidget = Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: screenWidth * 0.06,
                                  height: screenWidth * 0.06,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: (focusedIndex != null &&
                                              encryptedPhrase[index] ==
                                                  encryptedPhrase[
                                                      focusedIndex!])
                                          ? Colors.blue.shade800
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: !revealedLetters.contains(index)
                                        ? Transform.translate(
                                          offset: const Offset(1, -2),
                                          child: TextField(
                                              focusNode: focusNodes[index],
                                              controller: TextEditingController(
                                                text:
                                                    guessedLetters[index] ?? '',
                                              ),
                                              readOnly: true,
                                              textAlign: TextAlign.center,
                                              maxLength: 1,
                                              onTap: () {
                                                setState(() {
                                                  focusedIndex = index;
                                                  String encryptedChar =
                                                      encryptedPhrase[index];
                                                  for (int i = 0;
                                                      i <
                                                          encryptedPhrase
                                                              .length;
                                                      i++) {
                                                    if (encryptedPhrase[i] ==
                                                        encryptedChar) {
                                                      focusNodes[i]
                                                          ?.requestFocus();
                                                    }
                                                  }
                                                });
                                              },
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  _onKeyPressed(value);
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                counterText: '',
                                                border: InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _isDuplicateWithDifferentEncryption(
                                                            index,
                                                            guessedLetters)
                                                        ? Colors.red
                                                        : Colors.black,
                                              ),
                                            ),
                                        )
                                        : Transform.translate(
                                            offset: const Offset(1, -1),
                                            child: Text(
                                              guessedLetters[index] ?? '',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .black, // Style for revealed letters
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  char == ' ' ? ' ' : encryptedPhrase[index],
                                  // Display encrypted letter or space
                                  style: const TextStyle(
                                    fontSize: 14,
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
              ),
            ),
          ),

          // Custom Keyboard (Fixed at the bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomKeyboard(
                    onKeyPressed: _onKeyPressed,
                    onDeletePressed: _onDeletePressed,
                    usedLetters: usedLetters,
                    revealedLetters: revealedLetters.map((index) => guessedLetters[index]!).toSet(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDeletePressed;
  final Set<String> usedLetters;
  final Set<String> revealedLetters;

  const CustomKeyboard({
    Key? key,
    required this.onKeyPressed,
    required this.onDeletePressed,
    required this.usedLetters,
    required this.revealedLetters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ...[
          'A',
          'B',
          'C',
          'Ç',
          'D',
          'E',
          'F',
          'G',
          'Ğ',
          'H',
          'I',
          'İ',
          'J',
          'K',
          'L',
          'M'
        ].map((letter) => _buildKey(letter, screenWidth, revealedLetters)).toList(),
        ...['N', 'O', 'Ö', 'P', 'R', 'S', 'Ş', 'T', 'U', 'Ü', 'V', 'Y', 'Z']
            .map((letter) => _buildKey(letter, screenWidth, revealedLetters))
            .toList(),
        _buildDeleteButton(screenWidth),
      ],
    );
  }

  Widget _buildKey(String letter, double screenWidth, Set<String> revealedLetters) {
    bool isUsed = usedLetters.contains(letter);
    bool isRevealed = revealedLetters.contains(letter);

    return SizedBox(
      width: screenWidth * 0.09,
      height: screenWidth * 0.09,
      child: ElevatedButton(
        onPressed: (isUsed || isRevealed) ? null : () => onKeyPressed(letter),
        style: ElevatedButton.styleFrom(
          backgroundColor: isRevealed || isUsed
        ? Colors.blue.shade200.withOpacity(0.3)
            : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.blue.withOpacity(0.3),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          letter,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.18,
      height: screenWidth * 0.09,
      child: ElevatedButton(
        onPressed: onDeletePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: Colors.red.withOpacity(0.3),
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
      // Convert both to lowercase for case-insensitive comparison
      if (guessedLetters[i] == null ||
          guessedLetters[i]!.isEmpty ||
          guessedLetters[i]!.toLowerCase() != phrase[i].toLowerCase()) {
        isCorrect = false;
        break;
      }
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(isCorrect ? "Correct! 🎉" : "Incorrect! Try Again. ❌"),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
    ),
  );
}
