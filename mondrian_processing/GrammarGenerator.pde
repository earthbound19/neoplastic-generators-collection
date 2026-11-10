// DESCRIPTION
// GrammarGenerator.pde
// Generates one random sequence of letters A, B, C, and D on demand.
// The selected sequence has a uniformly chosen position in the complete
// set of all possible grammars of lengths 1 through maxTotalLength.
//
// Example with maxTotalLength=3:
// Length 1: A, B, C, D
// Length 2: AA, AB, AC, AD, BA, BB, BC, BD, CA, CB, CC, CD, DA, DB, DC, DD
// Length 3: AAA, AAB, AAC, AAD, ... DDD
//
// Repeated letters are unrestricted. The only limit is total string length.

class GrammarGenerator {
  int maxTotalLength;
  final String letters = "ABCD";
  long totalCount;

  // Constructor with default maximum total grammar length of 11.
  GrammarGenerator() {
    this(11);
  }

  // Constructor with custom maximum total grammar length.
  GrammarGenerator(int maxLen) {
    setMaxTotalLength(maxLen);
  }

  // Change the maximum dynamically without generating or storing grammars.
  void setMaxTotalLength(int maxLen) {
    if (maxLen < 1) {
      throw new IllegalArgumentException("Maximum grammar length must be at least 1.");
    }
    if (maxLen > 99) {
      throw new IllegalArgumentException("Maximum grammar length cannot exceed 99.");
    }

    maxTotalLength = maxLen;
    totalCount = calculateTotalCount(maxTotalLength);
  }

  // Sum 4^1 + 4^2 + ... + 4^maxTotalLength.
  // At the supported maximum of 26, this fits in a Java long and remains
  // below the exact-integer range of a double, which is used for selection.
  long calculateTotalCount(int maxLen) {
    long count = 0;
    long sequencesAtLength = 1;

    for (int len = 1; len <= maxLen; len++) {
      sequencesAtLength *= 4L;
      count += sequencesAtLength;
    }

    return count;
  }

  String getRandomGrammar() {
    // Select one index uniformly from the complete set of possible grammars.
    long randomIndex = (long)(Math.random() * (double)totalCount);

    // Determine which length contains the selected index.
    int selectedLength = 1;
    long sequencesAtLength = 4L;

    while (randomIndex >= sequencesAtLength) {
      randomIndex -= sequencesAtLength;
      selectedLength++;
      sequencesAtLength *= 4L;
    }

    // Convert the index within that length into a base-4 sequence.
    // Leading zero digits are retained, so every selected sequence has
    // exactly selectedLength letters.
    char[] result = new char[selectedLength];

    for (int position = selectedLength - 1; position >= 0; position--) {
      int digit = (int)(randomIndex % 4L);
      result[position] = letters.charAt(digit);
      randomIndex /= 4L;
    }

    String selected = new String(result);
    println("GrammarGenerator: Selected random grammar: " + selected);
    return selected;
  }

  long getTotalCount() {
    return totalCount;
  }

  int getMaxTotalLength() {
    return maxTotalLength;
  }
}
