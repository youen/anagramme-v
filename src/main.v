module main

import vsl.iter

import arrays

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

fn find_subseeds (seed string)  [][]string {
	ss := new_seed_splitter(seed)

	mut subseeds := [][]string{}
	for subseed in ss {
		subseeds << subseed
	}

	return subseeds

}

fn (a Anagramme) find( word string) []string {

	mut result :=  a.index[a.seed(word)]
	for  subseed in find_subseeds(a.seed(word)) {
		first_col := a.index[subseed[0]] or {  continue}
		second_col := a.index[subseed[1]] or {  continue}
		for first in first_col{
			for second in second_col {
				result << "${first} ${second}"
			}
		}
	}

	return arrays.distinct(result)
}

fn (a Anagramme) seed( word string) string {
	mut runes := word.replace(" ","").runes()
	runes.sort()
	return runes.string()
}

struct SeedSplitter {
	seed string
mut:
	k int
	choice_k_in ChoiceKIn
}

fn new_seed_splitter(seed string) SeedSplitter {
	return SeedSplitter {
		seed : seed,
		k : 2
		choice_k_in : new_choice_k_in(seed, 2)
	}
}

fn (mut s SeedSplitter) next() ?[]string {

	combi := s.choice_k_in.next() or { 
		if s.k < s.seed.len {
			s.k++
			s.choice_k_in = new_choice_k_in(s.seed, s.k)
			return s.next()
		}
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
