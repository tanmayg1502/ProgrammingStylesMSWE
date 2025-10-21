import Foundation

// The One - The wrapper abstraction
class TheOne<T> {
    private let value: T
    
    // Wrap a value
    init(_ value: T) {
        self.value = value
    }
    
    // Bind: apply a function to the wrapped value and wrap the result
    func bind<U>(_ function: (T) -> U) -> TheOne<U> {
        return TheOne<U>(function(self.value))
    }
    
    // Unwrap: extract the final value
    func unwrap() -> T {
        return self.value
    }
}

// All functions now take plain values and return plain values

func readFile(_ path: String) -> String {
    guard let data = try? String(contentsOfFile: path, encoding: .utf8) else {
        return ""
    }
    return data
}

func filterChars(_ data: String) -> String {
    let filtered = data.map { char -> Character in
        if char.isLetter || char.isNumber {
            return char
        } else {
            return " "
        }
    }
    return String(filtered)
}

func normalize(_ data: String) -> String {
    return data.lowercased()
}

func scan(_ data: String) -> [String] {
    return data.split(separator: " ").map { String($0) }
}

func removeStopWords(_ wordList: [String]) -> [String] {
    var stopWords = Set<String>()
    
    if let data = try? String(contentsOfFile: "../stop_words.txt", encoding: .utf8) {
        stopWords = Set(data.split(separator: ",").map { 
            String($0).trimmingCharacters(in: .whitespacesAndNewlines) 
        })
    }
    
    // Add single letters
    for char in "abcdefghijklmnopqrstuvwxyz" {
        stopWords.insert(String(char))
    }
    
    return wordList.filter { !stopWords.contains($0) }
}

func frequencies(_ wordList: [String]) -> [String: Int] {
    var wf: [String: Int] = [:]
    for word in wordList {
        wf[word, default: 0] += 1
    }
    return wf
}

func sort(_ wf: [String: Int]) -> [(String, Int)] {
    return wf.sorted { $0.value > $1.value }
}

func printTop25(_ wordFreqs: [(String, Int)]) -> [(String, Int)] {
    for (word, count) in wordFreqs.prefix(25) {
        print("\(word) - \(count)")
    }
    return wordFreqs
}

// Main program
guard CommandLine.arguments.count >= 2 else {
    print("Usage: swift ten.swift <input_file>")
    exit(1)
}

let inputPath = CommandLine.arguments[1]

// Solve the problem as a pipeline of functions bound together
let _ = TheOne(inputPath)
    .bind(readFile)
    .bind(filterChars)
    .bind(normalize)
    .bind(scan)
    .bind(removeStopWords)
    .bind(frequencies)
    .bind(sort)
    .bind(printTop25)
    .unwrap()