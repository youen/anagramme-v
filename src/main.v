module main

import vsl.iter

fn main() {

}

struct Anagramme {
	index map[string][]string
}

fn new_anagramme() Anagramme {
	return Anagramme{
		index : {
			"cehin" : ["chien", "niche"]
			"eegin" : ["genie", "neige"]
		}
	}
}

fn (a Anagramme) find( word string) []string {

	return a.index[a.seed(word)]
}

fn (a Anagramme) seed( word string) string {
	mut runes := word.runes()
	runes.sort()
	return runes.string()
}

struct SeedSplitter {
	seed string
mut:
	k = 0
	choice_k_in ChoiceKIn
}

fn new_seed_splitter(seed string) SeedSplitter {
	return SeedSplitter {
		seed : seed,
		choice_k_in : new_choice_k_in(seed, 5)
	}
}

fn (mut s SeedSplitter) next() ?[]string {

	combi := s.choice_k_in.next() or { 
		return none
		}

	mut first := ""
	mut second := ""
	for index in 0..s.seed.len {
		if index in combi {
			 first += s.seed[index].ascii_str()
		} else {

		second += s.seed[index].ascii_str()
		}


	}

	return [first, second]
}

struct ChoiceKIn {
mut:
	iter iter.CombinationsIter
}

fn new_choice_k_in(seed string, k int) ChoiceKIn {
	mut code := []f64{}
	for index in 0..seed.len {
		code << f64(index)
	}
	return ChoiceKIn {
		iter : iter.CombinationsIter.new(code, k)
	} 
}

fn (mut c ChoiceKIn) next() ?[]int {
	

	combi := c.iter.next() or { 
		return none
		} 

	mut combi_int := []int{}
	for n in combi {
		combi_int << int(n)
	}

	return combi_int
	
}
