{
	# cut the line into pieces divided by " - " and add them to hierarchy
	line = $0
	level = 1
	parent_idx = ""
	while (length(line)) {
		if (match(line, " - ")) {
			head = substr(line, 1, RSTART-1)
			line = substr(line, RSTART+RLENGTH)
		} else {
			head = line
			line = ""
		}

		if (!(head in idx_page) && (level < 3)) {
			#print "level=" level " page=" NR " head=" head
			idx[NR][level] = head
			idx_page[head] = NR
			if (level == 1) {
				idx_subcount[parent_head] = subcount
				subcount = 0
				parent_head = head
			} else {
				subcount = subcount+1
			}
		}
		level = level+1
	}
}

END {
	for (p = 1; p <= NR; p++) {
		if (length(idx[p][1])) {
			hd = idx[p][1]
			system("echo \"" hd "\" | iconv -t utf-16be >> utf16.txt")
			getline hd16 < "utf16.txt"
			hd16 = "\xFE\xFF" hd16
			if (idx_subcount[hd] > 0) {
				print "[/Count -" idx_subcount[hd] " /Title (" hd16 ") /Page " idx_page[hd] " /OUT pdfmark"
			} else {
				print "[/Title (" hd16 ") /Page " idx_page[hd] " /OUT pdfmark"
			}
		}

		if (length(idx[p][2])) {
			hd = idx[p][2]
			system("echo \"" hd "\" | iconv -t utf-16be >> utf16.txt")
			getline hd16 < "utf16.txt"
			hd16 = "\xFE\xFF" hd16
			print "[/Title (" hd16 ") /Page " idx_page[hd] " /OUT pdfmark"
		}
	}
	system("rm utf16.txt")
}
