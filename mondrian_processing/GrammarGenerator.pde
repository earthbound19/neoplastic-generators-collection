// DESCRIPTION
// GrammarGenerator.pde
// Generates all possible sequences of letters A,B,C,D where:
// - Each sequence length is between 1 and maxTotalLength
// - Letters can appear in any order (all permutations with repetition)
// - Total sequences = sum_{n=1}^{maxTotalLength} 4^n
// 
// Example with maxTotalLength=3: 
// Length 1: A, B, C, D
// Length 2: AA, AB, AC, AD, BA, BB, BC, BD, CA, CB, CC, CD, DA, DB, DC, DD
// Length 3: AAA, AAB, AAC, AAD, ... DDD
// 
// This gives ALL possible grammars, not just alphabetical-order grouped ones
// (a previous version did that).
//
// WARNING: This grows exponentially! 4^1 + 4^2 + ... + 4^N
// - N=4: 4 + 16 + 64 + 256 = 340 grammars
// - N=5: 4 + 16 + 64 + 256 + 1024 = 1364 grammars
// - N=6: 4 + 16 + 64 + 256 + 1024 + 4096 = 5460 grammars
// - N=7: 4 + 16 + 64 + 256 + 1024 + 4096 + 16384 = 21844 grammars
// - N=8: 4 + 16 + 64 + 256 + 1024 + 4096 + 16384 + 65536 = 87380 grammars
// 
// Use maxTotalLength carefully! Default 4 is safe and gives variety.

class GrammarGenerator {
  ArrayList<String> allGrammars;
  int maxTotalLength;
  String letters = "ABCD";
  
  // Constructor with default maxTotalLength = 4
  GrammarGenerator() {
    this(4);  // Default to 4
  }
  
  // Constructor with custom maxTotalLength
  GrammarGenerator(int maxLen) {
    maxTotalLength = maxLen;
    allGrammars = new ArrayList<String>();
    generateAllGrammars();
    println("Generated " + allGrammars.size() + " grammars (max length " + maxTotalLength + ")");
  }
  
  void generateAllGrammars() {
    // Generate all sequences from length 1 to maxTotalLength
    for (int len = 1; len <= maxTotalLength; len++) {
      generateSequences("", len);
    }
  }
  
  // Recursive helper to generate all sequences of exact length
  void generateSequences(String prefix, int remaining) {
    if (remaining == 0) {
      allGrammars.add(prefix);
      return;
    }
    for (int i = 0; i < letters.length(); i++) {
      generateSequences(prefix + letters.charAt(i), remaining - 1);
    }
  }
  
  String getRandomGrammar() {
    if (allGrammars.isEmpty()) return "AABBCCDDDDDD"; // fallback
    int randomIndex = (int)random(allGrammars.size());
    String selected = allGrammars.get(randomIndex);
    println("GrammarGenerator: Selected grammar #" + randomIndex + ": " + selected);
    return selected;
  }
  
  int getTotalCount() {
    return allGrammars.size();
  }
  
  int getMaxTotalLength() {
    return maxTotalLength;
  }
}