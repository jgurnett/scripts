import getopt, sys
from googleapi import google

def main(argv):
	inputfile = ""
	site = ""
	standing = {}
	try: 
		opts, args = getopt.getopt(argv, "hi:s:", ["ifile=", "site="])
	except getopt.GetoptError:
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print('you have reached the help menu')
			sys.exit()
		elif opt in ('-i', '--ifile'):
			inputfile = arg
			print('input file is: ' + inputfile)
		elif opt in ('-s', '--site'):
			site = arg
			print('site file is: ' + site)
	query = ""
	file = open(inputfile, 'r')
	Lines = file.readlines()
	for line in Lines:
		if '\n' in line:
			query = line.replace("\n", "")

		numPage = 3
		print("searching for: " + query + "...")
		searchResults = google.search(query, numPage)
		count = 0
		for result in searchResults:
			count = count + 1
			try:
				if site in result.link:
					page = 1
					position = count
					if count > 9:
						page = int(count / 10) + 1 
						position = count % 10
					standing[query] = "Page: " + str(page) + " position: " + str(position)
					print(standing[query])
					print()
			except:
				print("error!")
		if query not in standing:
			print('Query: ' + query + " not found!\n")

	print("Results :" + str(standing))


if __name__ == "__main__":
	main(sys.argv[1:])
