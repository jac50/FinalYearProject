# Tests for RunHead

- Sample Size < 0
- Sample Size Too Big
- Sample Size non number
- Directory not valid
- Original File not found


# Tests for createArguments

- argparse not compatible or not found ?

# Tests for initLogger

- Input Tests:
	+ Quiet - TRUE Verbose - FALSE . Expected Result: Set to Quiet Mode (lvl 30)
	+ Quiet - TRUE Verbose - TRUE  Expected Result: throw error. set to normal mode
	+ Quiet - FALSE Verbose - FALSE . Expected Result: set to normal mode
	+ Quiet - FALSE Verbose - TRUE . Expected Result: Set to Verbose mode (lvl 10)
	+ Quiet - NOT LOGICAL Verbose - TRUE Expected Result: Set to Verbose mode (lvl 10)
	+ Quiet - TRUE Verbose - NOT LOGICAL : Expected Result: Set to Quiet Mode (lvl 30)
	+ Quiet - NOT LOGICAL Verbose NOT LOGICAL - Expected Result: throw error. set to normal mode
- Other Tests:
	+ Directory does not exist
	+ Directory cannot be created

# Tests for ParseFileName
- Input Tests:
- Other Tests:

# Tests for readFile
- Input Tests:
- Other Tests:

# Tests for purgeData

- Input Tests:
- Other Tests:

# Tests for ParseFileName
- Input Tests:
- Other Tests:
