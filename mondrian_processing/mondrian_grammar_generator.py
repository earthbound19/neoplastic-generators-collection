#!/usr/bin/env python3

"""
DESCRIPTION
Mondrian Grammar Generator
Generate grammars that produce exactly N lines in a Mondrian composition.

The Processing sketch expects grouped grammars: A...B...C...D...
Since each successful operation adds exactly one line, a grammar of length N
will produce N lines if all operations succeed. IF no operations encounter
collision.

USAGE
python mondrian_grammar_generator.py -t TARGET_LINES_COUNT -n NUMBER_OF_GRAMMARS

EXAMPLES
Generate 5 grammars with exactly 30 lines:
    python mondrian_grammar_generator.py -t 30 -n 5
"""

import argparse
import random
import sys


def generate_grammar(target_lines: int) -> str:
    """Generate a grouped grammar of length target_lines."""
    
    # Ensure each letter appears at least once for a meaningful composition
    if target_lines < 4:
        # For very small grammars, just distribute randomly
        return ''.join(random.choice('ABCD') for _ in range(target_lines))
    
    # Start with 1 of each letter
    a = 1
    b = 1
    c = 1
    d = 1
    remaining = target_lines - 4
    
    # Distribute remaining lines randomly
    while remaining > 0:
        choice = random.choice(['A', 'B', 'C', 'D'])
        if choice == 'A':
            a += 1
        elif choice == 'B':
            b += 1
        elif choice == 'C':
            c += 1
        else:
            d += 1
        remaining -= 1
    
    # Build grouped grammar: all A's, then B's, then C's, then D's
    return 'A' * a + 'B' * b + 'C' * c + 'D' * d


def main():
    parser = argparse.ArgumentParser(
        description='Generate Mondrian grammars',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    parser.add_argument('-t', '--target-lines-count', type=int, required=True,
                       help='Desired number of lines in each grammar')
    parser.add_argument('-n', '--number-of-grammars', type=int, required=True,
                       help='Number of grammars to generate')
    parser.add_argument('--seed', type=int,
                       help='Random seed for reproducibility')
    
    args = parser.parse_args()
    
    if args.seed is not None:
        random.seed(args.seed)
    
    if args.target_lines_count < 1:
        print("Error: target-lines-count must be at least 1")
        sys.exit(1)
    
    print(f"Generating {args.number_of_grammars} grammars with exactly {args.target_lines_count} lines...")
    print()
    
    # Generate grammars
    grammars = []
    seen = set()
    
    while len(grammars) < args.number_of_grammars:
        grammar = generate_grammar(args.target_lines_count)
        
        if grammar not in seen:
            seen.add(grammar)
            grammars.append(grammar)
            print(f"[{len(grammars)}/{args.number_of_grammars}] {grammar}")
    
    print(f"\n{'='*60}")
    print(f"Generated {len(grammars)} grammars with exactly {args.target_lines_count} lines:")
    print(f"{'='*60}")
    
    for i, grammar in enumerate(grammars, 1):
        counts = {
            'A': grammar.count('A'),
            'B': grammar.count('B'),
            'C': grammar.count('C'),
            'D': grammar.count('D')
        }
        
        print(f"\n{i}. {grammar}")
        print(f"   Length: {len(grammar)}")
        print(f"   A={counts['A']:2d}, B={counts['B']:2d}, C={counts['C']:2d}, D={counts['D']:2d}")


if __name__ == "__main__":
    main()