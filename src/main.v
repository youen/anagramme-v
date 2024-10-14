module main

import vsl.iter
import os
import encoding.csv
import arrays

fn main() {
	mut anagramme := new_anagramme()
	anagramme.load_file('data/francais.txt')!
	anagramme.load_file('data/1grams_french.csv')!
	anagramme.load_file('data/2grams_french.csv')!
	anagramme.load_file('data/3grams_french.csv')!
	anagramme.load_file('data/4grams_french.csv')!
	anagramme.load_file('data/5grams_french.csv')!

	println('>>> ${os.args[1]}')
	for result in anagramme.find_iterator(os.args[1]) {
		println(result)
	}
}

// Anagramme is a struct used to store and manage a dictionary of words by their sorted characters, known as a seed.
struct Anagramme {
mut:
	index map[string][]string // Map storing the word seed and associated words
}

// new_anagramme initializes and returns a new Anagramme instance.
fn new_anagramme() Anagramme {
	return Anagramme{
		index: {}
	}
}

// find_subseeds generates all possible subseeds (combinations of the input seed split in two parts).
// This is used to recursively find anagram combinations of two or more words.
fn find_subseeds(seed string) [][]string {
	ss := new_seed_splitter(seed)

	mut subseeds := [][]string{}
	for subseed in ss {
		subseeds << subseed
	}

	return subseeds
}

// add adds a word to the anagram dictionary using its sorted characters (seed) as the key.
fn (mut a Anagramme) add(word string) {
	a.index[a.seed(word)] << word
}

// load_file reads a file and adds all words (from a CSV file or plain text) to the anagram dictionary.
fn (mut a Anagramme) load_file(filename string) ! {
	data := os.read_file(filename)!
	mut reader := csv.new_reader(data)
	// read header
	reader.read()!
	for {
		word := reader.read() or { break }
		a.add(word[0])
	}
}

// find returns a list of anagrams for a given word by iterating through potential matches.
fn (a Anagramme) find(word string) []string {
	mut result := []string{}
	for anagramme in a.find_iterator(word) {
		result << anagramme
	}
	return arrays.distinct(result)
}

// AnagrammeIteratorState is an enum representing different stages of iteration when finding anagrams.
enum AnagrammeIteratorState as u8 {
	start    // Start state of the iterator
	direct   // Direct lookup of words with the same seed
	subseed  // Iterating through subseeds (word combinations)
	recursive // Recursive search for anagram combinations
}

// AnagrammeIterator is used to iteratively search for anagrams in different stages.
struct AnagrammeIterator {
	anagramme Anagramme  // Reference to the Anagramme instance
	seed      string     // The seed (sorted characters of the word) being searched for
mut:
	ss     SeedSplitter                // The seed splitter used for generating subseeds
	state  AnagrammeIteratorState       // Current state of the iterator
	buffer []string                     // Buffer to store intermediate anagram results
	cache  map[string]bool              // Cache to avoid returning duplicate results
}

// find_iterator initializes an iterator to search for anagrams of a given word.
fn (a Anagramme) find_iterator(word string) AnagrammeIterator {
	seed := a.seed(word)
	return AnagrammeIterator{
		anagramme: a
		seed:      seed
		ss:        new_seed_splitter(seed)
		state:     AnagrammeIteratorState.start
	}
}

// next returns the next valid anagram, iterating through different stages of the search.
fn (mut a AnagrammeIterator) next() ?string {
	for {
		match a.state {
			.start {
				a.buffer = a.anagramme.index[a.seed]
				a.state = AnagrammeIteratorState.direct
			}
			.direct {
				if a.buffer.len > 0 {
					if a.buffer.last() in a.cache {
						a.buffer.pop()
						continue
					} else {
						result := a.buffer.pop()
						a.cache[result] = true
						return result
					}
				} else {
					a.state = AnagrammeIteratorState.subseed
				}
			}
			.subseed {
				if a.buffer.len > 0 {
					return a.buffer.pop()
				} else {
					subseed := a.ss.next() or {
						a.state = AnagrammeIteratorState.recursive
						a.ss = new_seed_splitter(a.seed)
						continue
					}
					first_col := a.anagramme.index[subseed[0]] or { continue }
					second_col := a.anagramme.index[subseed[1]] or { continue }
					for first in first_col {
						for second in second_col {
							result := '${first} ${second}'
							ratio := f64(result.count(' ')) / f64(result.len)
							if ratio > 0.1 {
								continue
							}
							if result !in a.cache {
								a.cache[result] = true
								a.buffer << result
							}
						}
					}
				}
			}
			.recursive {
				if a.buffer.len > 0 {
					return a.buffer.pop()
				} else {
					subseed := a.ss.next() or { return none }
					first_col := a.anagramme.index[subseed[0]] or { continue }
					for first in first_col {
						for second in a.anagramme.find_iterator(subseed[1]) {
							result := '${first} ${second}'
							ratio := f64(result.count(' ')) / f64(result.len)
							if ratio > 0.2 {
								continue
							}
							if result !in a.cache {
								a.cache[result] = true
								a.buffer << result
							}
						}
					}
				}
			}
		}
	}
	return none
}

// seed returns the sorted characters of a word, used as a key for finding anagrams.
fn (a Anagramme) seed(word string) string {
	mut runes := word.replace(' ', '').runes()
	runes.sort()
	return runes.string()
}

// SeedSplitter is used to split the seed (sorted characters) of a word into subseeds.
struct SeedSplitter {
	seed string            // The seed being split
mut:
	k           int          // Length of the split
	choice_k_in ChoiceKIn    // Combination iterator used to generate splits
}

// new_seed_splitter initializes a new SeedSplitter with the given seed.
fn new_seed_splitter(seed string) SeedSplitter {
	return SeedSplitter{
		seed:        seed
		k:           2
		choice_k_in: new_choice_k_in(seed, 2)
	}
}

// next generates the next possible split of the seed into two subseeds.
fn (mut s SeedSplitter) next() ?[]string {
	combi := s.choice_k_in.next() or {
		if s.k < s.seed.len {
			s.k++
			s.choice_k_in = new_choice_k_in(s.seed, s.k)
			return s.next()
		}
		return none
	}

	mut first := ''
	mut second := ''
	for index in 0 .. s.seed.len {
		if index in combi {
			first += s.seed[index].ascii_str()
		} else {
			second += s.seed[index].ascii_str()
		}
	}

	return [first, second]
}

// ChoiceKIn is used to generate combinations of indices for splitting a seed.
struct ChoiceKIn {
mut:
	iter iter.CombinationsIter // Iterator for generating combinations
}

// new_choice_k_in initializes a new ChoiceKIn for the given seed and combination length k.
fn new_choice_k_in(seed string, k int) ChoiceKIn {
	mut code := []f64{}
	for index in 0 .. seed.len {
		code << f64(index)
	}
	return ChoiceKIn{
		iter: iter.CombinationsIter.new(code, k)
	}
}

// next returns the next combination of indices for splitting the seed.
fn (mut c ChoiceKIn) next() ?[]int {
	combi := c.iter.next() or { return none }

	mut combi_int := []int{}
	for n in combi {
		combi_int << int(n)
	}

	return combi_int
}
