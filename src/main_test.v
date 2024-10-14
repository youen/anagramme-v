module main

// test_anagrame tests the basic functionalities of the anagram search system.
// It checks if the anagram search correctly finds single-word anagrams, 
// multi-word combinations, and recursively finds valid multi-word combinations.
fn test_anagrame() {
	mut anagramme := new_anagramme()
	anagramme.add('chien')  // 'dog' in French
	anagramme.add('niche')  // 'niche' in French
	anagramme.add('genie')  // 'genius' in French
	anagramme.add('neige')  // 'snow' in French

	// Test direct anagram matching
	assert 'niche' in anagramme.find('chien')
	assert 'neige' in anagramme.find('genie')

	// Test combination of two anagrams
	assert 'neige niche' in anagramme.find('chien genie')
	// Test all possible combinations of two anagrams
	assert ['chien genie', 'chien neige', 'genie chien', 'genie niche', 'neige chien', 'neige niche',
		'niche genie', 'niche neige'] == anagramme.find('chien genie')

	// Test three-word anagram combination
	assert "neige niche genie" in anagramme.find("chien genie neige")
}

// test_anagrame_iterator tests the iterator functionality for finding anagrams.
// It checks the correct behavior of the iterator when searching for both single
// and multi-word anagrams, ensuring that the iterator correctly yields results.
fn test_anagrame_iterator() {
	mut anagramme := new_anagramme()
	anagramme.add('chien')
	anagramme.add('niche')
	anagramme.add('genie')
	anagramme.add('neige')

	// Test the iterator for a single word
	mut result := anagramme.find_iterator('chien')
	assert result.next() or { '' } == 'niche'

	// Test the iterator for two words
	result = anagramme.find_iterator('chien genie')
	assert result.next() or { '' } == 'niche neige'
}

// test_seed_spliter checks the seed splitter functionality which splits a seed
// into valid combinations. It ensures that the seed is split correctly into possible
// subseeds that can form combinations of valid anagrams.
fn test_seed_spliter() {
	assert ['ce', 'hin'] in find_subseeds('cehin')  // 'chien' as subseeds
	assert ['ee', 'gin'] in find_subseeds('eegin')  // 'genie' as subseeds
	assert ['eg', 'ein'] in find_subseeds('eegin')  // alternative split for 'genie'
	assert ['cehin', 'eegin'] in find_subseeds('ceeeghiinn')  // complex seed split
}

// test_choice_k_in tests the combination generator (ChoiceKIn).
// It ensures that for a given string and a combination size, the correct 
// indices for combinations are generated.
fn test_choice_k_in() {
	s := 'abc'
	mut allcombi := [][]int{}

	ckin := new_choice_k_in(s, 2)

	// Collect all combinations of length 2 from 'abc'
	for combi in ckin {
		allcombi << combi
	}

	// Check that the combinations are correct
	assert allcombi == [
		[0, 1], // 'ab'
		[0, 2], // 'ac'
		[1, 2], // 'bc'
	]
}
