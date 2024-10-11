module main


fn test_anagrame () {
	anagramme := new_anagramme()
	
	assert "niche" in anagramme.find("chien")
	assert "neige" in anagramme.find("genie")

	//assert "neige niche" in anagramme.find("chien genie")

}

fn find_subseeds (seed string)  [][]string {
	ss := new_seed_splitter(seed)

	mut subseeds := [][]string{}
	for subseed in ss {
		subseeds << subseed
	}

	return subseeds

}

fn test_seed_spliter() {

	assert ["ce", "hin"] in find_subseeds("cehin")
	assert ["ee", "gin"] in find_subseeds("eegin")
	assert ["eg", "ein"] in find_subseeds("eegin")
	assert ["cehin", "eegin"] in find_subseeds("ceeeghiinn")

}

fn test_choice_k_in() {
	
	s :="abc"
	mut allcombi := [][]int{}

	ckin := new_choice_k_in(s, 2)
	
	for combi in ckin {
		allcombi << combi
	}

	assert allcombi == [
		[0, 1],
		[0, 2],
		[1, 2],
	]
}