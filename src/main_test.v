module main


fn test_anagrame () {
	mut anagramme := new_anagramme()
	anagramme.add("chien")
	anagramme.add("niche")
	anagramme.add("genie")
	anagramme.add("neige")
	
	assert "niche" in anagramme.find("chien")
	assert "neige" in anagramme.find("genie")

	assert "neige niche" in anagramme.find("chien genie")
	assert  ['chien genie', 'chien neige', 'genie chien', 'genie niche', 'neige chien', 'neige niche', 'niche genie', 'niche neige'] == anagramme.find("chien genie")

	// assert "neige niche genie" in anagramme.find("chien genie neige")

}

fn test_anagrame_iterator () {
	mut anagramme := new_anagramme()
	anagramme.add("chien")
	anagramme.add("niche")
	anagramme.add("genie")
	anagramme.add("neige")

	mut result := anagramme.find_iterator("chien")
	assert result.next() or { "" } == "niche"


	//result = anagramme.find_iterator("chien genie")
	//assert result.next() or { "" } == "neige niche"

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