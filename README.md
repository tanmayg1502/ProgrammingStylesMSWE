# SWE 262P - Weekly Exercises

## Week 1: Term Frequency

Simple Swift program that counts word frequencies in a text file and prints the top 25 most common words (excluding stop words).

### Setup

Make sure you have these files in your Assignments directory:
- `Swift Compiler installed`
- `stop_words.txt`
- `pride-and-prejudice.txt`

### Running the Program

From the week1 folder:

```
cd Assignments
```

```
swift Week1_exercise.swift pride-and-prejudice.txt
```

### What it does

- Reads the input text file
- Filters out common words (from stop_words.txt) and single letters
- Counts how many times each word appears
- Prints the 25 most frequent words with their counts

### Output format

```
word  -  count
```

Example:
```
mr  -  786
elizabeth  -  635
very  -  488
darcy  -  418
such  -  395
mrs  -  343
much  -  329
more  -  327
bennet  -  323
bingley  -  306
jane  -  295
miss  -  283
one  -  275
know  -  239
before  -  229
herself  -  227
though  -  226
well  -  224
never  -  220
sister  -  218
soon  -  216
think  -  211
now  -  209
time  -  203
good  -  201
```

### Notes

- Words are case-insensitive
- Only keeps words with 2+ characters
- Results sorted by frequency, then alphabetically
