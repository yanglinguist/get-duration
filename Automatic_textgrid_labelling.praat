# Yang Li, Yangli-linguistics.com
# 20 Dec 2016

# This script labels a textgrid with information from a user-supplied text file. 
# To save you from the trouble of typing every interval manually. 

# The ideal workflow for creating an annotated textgrid for a recording is to: 
# 1. prepare a text file, with each label occupying a line. You should more or less already have this - your word list. 
# 2. create a textgrid, segment the boundary of each interval you want to label. 
# 3. now, use this script to fill the textgrid with labels from your word list.
# 4. a textgrid called "annotated + original_textgrid_name" will be generated in the object window,
# which has an empty interval, followed by a filled interval, filled by another empty interval, and so on. 

# You need to specify:
# 1. which tier of the textgrid you want to label.
# 2. the first interval you want to label. This is typically the 2nd.

# You will then be prompted to select (in order):
# 1. your annotation file, which is a txt file with each label occupying one line. 
# 2. your textgrid file, with more or less determined boundaries but no labels yet. 

# Note:
# * Mac users need to make sure that the txt file consists of only plain text. 
# In the TextEdit app, go to Format - Make Plain Text to achieve this.

#####################################################################################################

# User input
form Tier and interval
comment Which tier do you want to label?
integer tier_to_label 1
comment Which interval is the first you want to fill?
integer first_interval 2
comment In the next menu, please select the txt file and the textgrid file, in order.
endform

# pauseScript: "This script will overwrite existing labels, sure you want to continue?"

# Pass user input
annotation$ = chooseReadFile$: "Open the annotation file - must be in txt format"

    # Check that the string is not empty
	if annotation$ = ""
		exit The text file is empty.
	endif

# Read the string file and get id
string_id = Read Strings from raw text file... 'annotation$'

# Get input on textgrid and make a copy of the opened textgrid 
textgrid_to_label$ = chooseReadFile$: "Open the textgrid file"
Read from file... 'textgrid_to_label$'

	# get the name of imported textgrid
	name_of_old_textgrid$ = selected$()
	# appendInfoLine: name_of_old_textgrid$

	# copy so that original textgrid is not overwritten
	tmp$ = "annotated " + name_of_old_textgrid$
	Copy: tmp$

	# select new textgrid ID and get number of intervals
	textgrid_ID = selected() 
	number_of_intervals = Get number of intervals... tier_to_label

# Loop over every other interval and fill with every line from string file

    # Start from first word of the string file
    label_number = 1

	for interval from first_interval to number_of_intervals

		# Select string, get one line for label, push to next line
		selectObject: string_id
		new_label$ = Get string... label_number
		label_number = label_number + 1

		# Reselect textgrid and set the interval text
		selectObject: textgrid_ID
		Set interval text... tier_to_label interval 'new_label$'
         
        # jump over one interval
		interval = interval + 1

	endfor

selectObject: string_id
Remove

########





