import Foundation

// Character-level file reader
class CharReader {
    private let data: Data
    private var position: Int = 0
    
    init(path: String) throws {
        self.data = try Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    func nextChar() -> Character? {
        guard position < data.count else { return nil }
        let byte = data[position]
        position += 1
        return Character(UnicodeScalar(byte))
    }
}

// Recursive word parsing - parses in chunks to avoid deep recursion
func parseWords(reader: CharReader, words: [String], stopWords: Set<String>, chunkSize: Int = 100) -> [String] {
    var currentWords = words
    var wordsInChunk = 0
    var currentWord = ""
    
    // Iterate to build multiple words in this chunk
    while let char = reader.nextChar() {
        if char.isLetter || char.isNumber {
            currentWord.append(char.lowercased())
        } else if !currentWord.isEmpty {
            // Found a complete word
            if !stopWords.contains(currentWord) {
                currentWords.append(currentWord)
            }
            currentWord = ""
            wordsInChunk += 1
            
            // Recurse after processing a chunk of words
            if wordsInChunk >= chunkSize {
                return parseWords(reader: reader, words: currentWords, stopWords: stopWords, chunkSize: chunkSize)
            }
        }
    }
    
    // Handle last word if file ends with alphanumeric
    if !currentWord.isEmpty && !stopWords.contains(currentWord) {
        currentWords.append(currentWord)
    }
    
    return currentWords
}

// Load stop words
func loadStopWords() -> Set<String> {
    guard let data = try? String(contentsOfFile: "../stop_words.txt", encoding: .utf8) else {
        return Set()
    }
    
    var stopWords = Set(data.lowercased().split(separator: ",").map { String($0) })
    
    // Add single letters a-z
    for char in "abcdefghijklmnopqrstuvwxyz" {
        stopWords.insert(String(char))
    }
    
    return stopWords
}

// Main program
guard CommandLine.arguments.count >= 2 else {
    print("Usage: swift eight.swift <input_file>")
    exit(1)
}

let inputPath = CommandLine.arguments[1]
let stopWords = loadStopWords()

do {
    let reader = try CharReader(path: inputPath)
    
    // Recursively parse all words
    let words = parseWords(reader: reader, words: [], stopWords: stopWords)
    
    // Count word frequencies (non-recursive)
    var wordFreqs: [String: Int] = [:]
    for word in words {
        wordFreqs[word, default: 0] += 1
    }
    
    // Sort and print top 25
    let sortedWords = wordFreqs.sorted { $0.value > $1.value }
    for (word, count) in sortedWords.prefix(25) {
        print("\(word) - \(count)")
    }
    
} catch {
    print("Error reading file: \(error)")
    exit(1)
}