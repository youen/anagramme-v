module main

import vsl.iter

fn main() {
	s :="abc"
	println(s)
	mut allcombi := []string{}

	ckin := new_choice_k_in(s, 2)
	
	for combi in ckin {
		allcombi << combi
	}

	println(allcombi)
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
	k int = 2
}

fn (s SeedSplitter) next() ?[]string {
	return none
}

struct ChoiceKIn {
mut:
	iter iter.CombinationsIter
}

fn new_choice_k_in(seed string, k int) ChoiceKIn {
	mut code := []f64{}
	for l in seed.bytes() {
		code << f64(l)
	}
	return ChoiceKIn {
		iter : iter.CombinationsIter.new(code, k)
	} 
}

fn (mut c ChoiceKIn) next() ?string {
	

	combi := c.iter.next() or { 
		return none
		} 

	mut combi_u8 := []u8{}
	for n in combi {
		combi_u8 << u8(n)
	}

	return combi_u8.bytestr()
	
}
