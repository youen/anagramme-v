module main


fn test_anagrame () {
	anagramme := new_anagramme()
	
	assert "niche" in anagramme.find("chien")
	assert "neige" in anagramme.find("genie")
	//assert "neige niche" in anagramme.find("chien genie")

}

fn test_seed_spliter() {
	
	ss := SeedSplitter{
		seed : "eegin"
	}

	mut subseeds := [][]string{}
	for subseed in ss {
		subseeds << subseed
	}

	assert subseeds == [
	]
}

fn test_choice_k_in() {
	
	s :="abc"
	mut allcombi := []string{}

	ckin := new_choice_k_in(s, 2)
	
	for combi in ckin {
		allcombi << combi
	}

	assert allcombi == [
		'ab',
		'ac',
		'bc',
	]
}