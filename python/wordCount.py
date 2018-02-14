import argparse
import string
import sys
from collections import Counter


# Process input arguments
parser = argparse.ArgumentParser(description='Count each word in a file')
parser.add_argument('--file', help='The file to perform a word count on', type=str, required=True)
args = vars(parser.parse_args())

fileName = args['file']


# Read file in
file=open(fileName,"r+")
fileContents = file.read()

# Remove all punctuation
fileContentsCleaned = fileContents.translate(None, string.punctuation)

# Convert all to lower case
fileContentsCleaned = fileContentsCleaned.lower()

# Count each unique word in the file
wordCount = Counter(fileContentsCleaned.split())

# Output ten most common words in descending order
print(wordCount.most_common(10))
