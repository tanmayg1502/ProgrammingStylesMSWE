import Foundation

// Read file and pass data to next function
func readFile(_ path: String, _ cont: (String) -> Void) {
    guard let data = try? String(contentsOfFile: path, encoding: .utf8) else {
        print("Error reading file")
        return
    }
    cont(data)
}

// Filter non-alphanumeric characters
func filterChars(_ data: String, _ cont: (String) -> Void) {
    let filtered = data.map { char -> Character in
        if char.isLetter || char.isNumber {
            return char
        } else {
            return " "
        }
    }
    cont(String(filtered))
}

// Convert to lowercase
func normalize(_ data: String, _ cont: (String) -> Void) {
    cont(data.lowercased())
}

// Split into words
func scan(_ data: String, _ cont: ([String]) -> Void) {
    let words = data.split(separator: " ").map { String($0) }
    cont(words)
}

// Remove stop words
func removeStopWords(_ wordList: [String], _ cont: ([String]) -> Void) {
    var stopWords = Set<String>()
    
    if let data = try? String(contentsOfFile: "../stop_words.txt", encoding: .utf8) {
        stopWords = Set(data.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) })
    }
    
    // Add single letters
    for char in "abcdefghijklmnopqrstuvwxyz" {
        stopWords.insert(String(char))
    }
    
    let filtered = wordList.filter { !stopWords.contains($0) }
    cont(filtered)
}

// Count word frequencies
func frequencies(_ wordList: [String], _ cont: ([String: Int]) -> Void) {
    var wf: [String: Int] = [:]
    for word in wordList {
        wf[word, default: 0] += 1
    }
    cont(wf)
}

// Sort by frequency
func sort(_ wf: [String: Int], _ cont: ([(String, Int)]) -> Void) {
    let sorted = wf.sorted { $0.value > $1.value }
    cont(sorted)
}

// Print top 25 words
func printText(_ wordFreqs: [(String, Int)], _ cont: () -> Void) {
    for (word, count) in wordFreqs.prefix(25) {
        print("\(word) - \(count)")
    }
    cont()
}

// No-op function to terminate the chain
func noOp() {
    return
}

// Main program
guard CommandLine.arguments.count >= 2 else {
    print("Usage: swift nine.swift <input_file>")
    exit(1)
}

let inputPath = CommandLine.arguments[1]

// Chain all the functions together in continuation-passing style
readFile(inputPath) { data in
    filterChars(data) { filtered in
        normalize(filtered) { normalized in
            scan(normalized) { words in
                removeStopWords(words) { filtered in
                    frequencies(filtered) { freqs in
                        sort(freqs) { sorted in
                            printText(sorted, noOp)
                        }
                    }
                }
            }
        }
    }
}