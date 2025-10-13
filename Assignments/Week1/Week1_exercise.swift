import Foundation

// Read command line arguments
guard CommandLine.arguments.count > 1 else {
    print("Usage: swift Main.swift <input_file>")
    exit(1)
}

let inputFilePath = CommandLine.arguments[1]
let stopWordsPath = "../stop_words.txt"

// Read stop words
guard let stopWordsContent = try? String(contentsOfFile: stopWordsPath, encoding: .utf8) else {
    print("Error: Could not read stop_words.txt")
    exit(1)
}

var stopWords = Set(stopWordsContent.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces).lowercased() })
// Add single letter words to stop words
for char in "abcdefghijklmnopqrstuvwxyz" {
    stopWords.insert(String(char))
}

// Read input file
guard let inputContent = try? String(contentsOfFile: inputFilePath, encoding: .utf8) else {
    print("Error: Could not read input file: \(inputFilePath)")
    exit(1)
}

// Process text and count word frequencies
var wordFreq: [String: Int] = [:]
let lowercasedContent = inputContent.lowercased()

// Extract words (alphanumeric characters only)
var currentWord = ""
for char in lowercasedContent {
    if char.isLetter || char.isNumber {
        currentWord.append(char)
    } else {
        if !currentWord.isEmpty {
            if !stopWords.contains(currentWord) && currentWord.count >= 2 {
                wordFreq[currentWord, default: 0] += 1
            }
            currentWord = ""
        }
    }
}
// Don't forget the last word if the file doesn't end with a separator
if !currentWord.isEmpty {
    if !stopWords.contains(currentWord) && currentWord.count >= 2 {
        wordFreq[currentWord, default: 0] += 1
    }
}

// Sort by frequency (descending) and then alphabetically
let sortedWords = wordFreq.sorted { first, second in
    if first.value != second.value {
        return first.value > second.value
    }
    return first.key < second.key
}

// Print top 25 words
for (_, pair) in sortedWords.prefix(25).enumerated() {
    print("\(pair.key)  -  \(pair.value)")
}