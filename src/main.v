module main

import vsl.iter
import os
import encoding.csv
import arrays

fn main() {
	mut anagramme := new_anagramme()
	anagramme.load_file("data/francais.txt")!
	anagramme.load_file("data/1grams_french.csv")!
	anagramme.load_file("data/2grams_french.csv")!
	anagramme.load_file("data/3grams_french.csv")!
	anagramme.load_file("data/4grams_french.csv")!
	anagramme.load_file("data/5grams_french.csv")!


//	println(anagramme.find("lino pimo")) // mini pool
//	println(anagramme.find("adrien youen")) // 'denier noyau'
//	println(anagramme.find("cgi n est pas a vendre")) // 'passant divergence'
//	println(anagramme.find("eric simon")) // roi mince
//	println(anagramme.find("france travail")) // 'flairer vacant' 
//	println(anagramme.find("cgi n est pas a vendre"))
	println(os.args[1])
	println(anagramme.find(os.args[1]))
	
}

struct Anagramme {
mut:
	index map[string][]string
}

fn new_anagramme() Anagramme {
	return Anagramme{
		index : {

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

fn (mut a Anagramme) add( word string)  {

	a.index[a.seed(word)] << word

}

fn (mut a Anagramme) load_file(filename string) ! {
	data := os.read_file(filename) !
    mut reader := csv.new_reader(data)
	// read header
	reader.read() !
    for {
        word := reader.read() or {
            break
        }
        a.add(word[0])
    }
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

enum AnagrammeIteratorState as u8 {
	start
	direct
	subseed
}

struct AnagrammeIterator {
	anagramme Anagramme
	seed string

mut:
	ss SeedSplitter
	state AnagrammeIteratorState
	buffer []string

}

fn (a Anagramme) find_iterator( word string) AnagrammeIterator {
	seed := a.seed(word)
	return AnagrammeIterator{
		anagramme : a
		seed : seed
		ss : new_seed_splitter(seed)
		state : AnagrammeIteratorState.start
	}

}

fn (mut a AnagrammeIterator) next() ?string {
	match a.state {
		.start {
			a.buffer = a.anagramme.index[a.seed]
			a.state = AnagrammeIteratorState.direct
			return a.next()

		}
		.direct {
			if a.buffer.len > 0 {
				return a.buffer.pop()

			} else {
				a.state = AnagrammeIteratorState.subseed
				return a.next()
			}

		}
		.subseed {
			if a.buffer.len > 0 {
				return a.buffer.pop()

			} else {
				subseed := a.ss.next() or { return none}
				first_col := a.anagramme.index[subseed[0]] or {  return a.next()  }
				second_col := a.anagramme.index[subseed[1]] or { return a.next( ) }
				for first in first_col{
					for second in second_col {
						a.buffer << "${first} ${second}"
					}
				}
				return a.next()
			}

		}
	}
	
	return none

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
