extends Node

var words_scores = {
	2: {"mult": 2, "points": 20, "mult_up": 1, "points_up": 10, "count": 0},
	3: {"mult": 3, "points": 30, "mult_up": 1, "points_up": 15, "count": 0},
	4: {"mult": 4, "points": 40, "mult_up": 2, "points_up": 20, "count": 0},
	5: {"mult": 5, "points": 50, "mult_up": 2, "points_up": 25, "count": 0},
	6: {"mult": 6, "points": 60, "mult_up": 3, "points_up": 30, "count": 0},
	7: {"mult": 7, "points": 70, "mult_up": 3, "points_up": 35, "count": 0},
	8: {"mult": 8, "points": 80, "mult_up": 4, "points_up": 40, "count": 0},
	9: {"mult": 9, "points": 90, "mult_up": 4, "points_up": 45, "count": 0},
	10: {"mult": 10, "points": 100, "mult_up": 5, "points_up": 50, "count": 0},
	11: {"mult": 11, "points": 110, "mult_up": 5, "points_up": 55, "count": 0},
	12: {"mult": 12, "points": 120, "mult_up": 6, "points_up": 60, "count": 0},
}

func get_word_score(word):
	var word_s = words_scores[len(word)]
	return {"mult": word_s["mult"], "points": word_s["points"]}
	
func upgrade_word_score(word):
	words_scores[len(word)]["mult"] += words_scores[len(word)]["mult_up"]
	words_scores[len(word)]["points"] += words_scores[len(word)]["points"]
	
func update_word_count(word):
	words_scores[len(word)]["count"] += 1
