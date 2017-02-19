# Yang Li, Yangli-linguistics.com
# 10 Oct 2016

# This script returns the durations filled intervals for all textgrids in a folder. 
# You will obtain a txt file which lists the file name, the interval name,
# and the duration of those intervals in ms. 

# You need to specify
# 1. the input directory
# 2. the results file name
# 3. which tier you want the script to read


form Duration for filled intervals for textgrids in folder
	comment Specify directory of the textgrids
	text InputDir ./
	comment Specify path and file name for the results text file
	text results ./results.txt
	comment Specify which tier
	integer Tier 1
endform

if fileReadable: results$
		pauseScript: results$ + " exists! Sure you want to overwrite that?"
	endif


Create Strings as file list... list_of_textgrid 'InputDir$'/*.TextGrid
numberOfStrings = Get number of strings

if numberOfStrings = 0
    pauseScript: "There is no textgrid in the folder!"
    exit
endif


	# Create a header row, including "order"
	header$ = "Filename" + tab$
	... + "label" + tab$ 
	... + "duration (ms)" + tab$
	... + "order"

	writeFileLine: results$, "'header$'"

	# Loop over textgrids
	for ifile to numberOfStrings
	    select Strings list_of_textgrid
		name_of_textgrid$ = Get string... ifile
		Read from file... 'InputDir$'/'name_of_textgrid$'
		id_of_textgrid = selected()

		# Select intervals

		numberOfIntervals = Get number of intervals... tier

	
		## Measure duration
		
		# order = 0 to track the number of interval 
        order = 0

		for interval to numberOfIntervals
			label$ = Get label of interval... tier interval

			# measure only if label is not empty
			if label$ <> ""
				# duration:
				start = Get starting point... tier interval
				end = Get end point... tier interval
				duration = (end-start) * 1000
				
				# order + 1 to track
				order = order + 1

				# Append duration and label to text files

				appendFileLine: results$, "'name_of_textgrid$'", tab$, "'label$'", tab$, duration, tab$, order

				# Iterate to next
				selectObject: id_of_textgrid
			endif

		endfor

		# remove textgrid
		selectObject: id_of_textgrid
		Remove

		# loop start over
		select Strings list_of_textgrid

	endfor

	select all
	Remove

### Updates
# 21 Dec 2016: streamlined syntax; changed display of results; added "order" to track label numbers
#