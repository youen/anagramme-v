# Anagramme-V

Anagramme-V is a V programming language-based tool designed to find meaningful anagrams for given words or phrases. The tool is particularly useful for analyzing French text, as it utilizes frequency data of French words and n-grams to prioritize the most relevant anagram combinations.

## Compilation

To compile the tool, use the following command:

```bash
v . --prod
```

This will produce a binary called `anagramme-v`.

## Usage

Once compiled, you can run the tool with a phrase to search for its anagrams. For example:

```bash
./anagramme-v 'chien neige'
```

The tool will output possible anagram combinations, with a focus on meaningful word pairings. For example:

```
>>> chien neige
chine neige
chine genie
chien neige
chien genie
neige chine
neige chien
genie chine
genie chien
ci gene hein
```

## Testing

To run the test suite, use:

```bash
v test .
```

This will run the unit tests included in the code to validate the functionality of the anagram finding algorithm.

## Reference Files

Anagramme-V relies on several reference files located in the `data/` directory. These files include French words and their n-gram frequencies, which are used to prioritize meaningful anagram combinations:

```bash
ls -l data
total 716
-rw-r--r--    1 root     root        297831 Oct 12 14:31 1grams_french.csv
-rw-r--r--    1 root     root         86164 Oct 12 14:31 2grams_french.csv
-rw-r--r--    1 root     root         60138 Oct 12 14:31 3grams_french.csv
-rw-r--r--    1 root     root         23417 Oct 12 14:31 4grams_french.csv
-rw-r--r--    1 root     root         27431 Oct 12 14:31 5grams_french.csv
-rw-r--r--    1 root     root        228263 Oct 12 20:38 francais.txt
```

These files are loaded by the program to optimize the search for anagrams, focusing on word combinations that are more likely to make sense in the French language.

## Algorithm and Search Optimization

Anagramme-V's algorithm limits its search to focus on word combinations that are more meaningful in French. It uses n-grams (word frequency data) from the reference files to prioritize certain word pairings, avoiding less likely or nonsensical combinations. This helps to ensure that the returned anagrams are plausible within the context of the French language.

By progressively filtering the combinations, the algorithm first searches for direct word matches, then splits the input phrase into sub-components, and finally tries recursive combinations. Throughout this process, it filters out results that do not meet a certain threshold of "word-to-space ratio," ensuring that the final anagram outputs are coherent phrases.