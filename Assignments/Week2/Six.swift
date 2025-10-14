import Foundation

// MARK: - Functions

// 1. Read file -> String
func readFile(_ path: String) -> String {
    guard let data = FileManager.default.contents(atPath: path) else { return "" }
    var content = ""
    for byte in data {
        let c = Character(UnicodeScalar(byte))
        content.append(c)
    }
    return content
}

// 2. Replace non-alphanumeric with space + lowercase
func filterCharsAndNormalize(_ text: String) -> String {
    var result = ""
    for c in text {
        if let ascii = c.asciiValue {
            if (ascii >= 48 && ascii <= 57) || (ascii >= 65 && ascii <= 90) || (ascii >= 97 && ascii <= 122) {
                // alphanumeric
                if ascii >= 65 && ascii <= 90 {
                    result.append(Character(UnicodeScalar(ascii + 32))) // A–Z → a–z
                } else {
                    result.append(c)
                }
            } else {
                result.append(" ")
            }
        } else {
            result.append(" ")
        }
    }
    return result
}

// 3. Scan string → words
func scan(_ text: String) -> [String] {
    var words: [String] = []
    var current = ""
    for c in text {
        if c == " " {
            if current != "" {
                words.append(current)
                current = ""
            }
        } else {
            current.append(c)
        }
    }
    if current != "" {
        words.append(current)
    }
    return words
}

// 4. Remove stop words
func removeStopWords(_ wordList: [String]) -> [String] {
    var stopWords: [String] = []
    if let stopData = FileManager.default.contents(atPath: "../stop_words.txt") {
        var current = ""
        for byte in stopData {
            let c = Character(UnicodeScalar(byte))
            if c == "," {
                if current != "" {
                    stopWords.append(current)
                    current = ""
                }
            } else {
                // lowercase manually
                if let ascii = c.asciiValue, ascii >= 65 && ascii <= 90 {
                    current.append(Character(UnicodeScalar(ascii + 32)))
                } else {
                    current.append(c)
                }
            }
        }
        if current != "" {
            stopWords.append(current)
        }
    }
    // add a–z
    var i = 97
    while i <= 122 {
        stopWords.append(String(UnicodeScalar(i)!))
        i += 1
    }

    // manual filtering
    var result: [String] = []
    var idx = 0
    while idx < wordList.count {
        var j = 0
        var isStop = false
        while j < stopWords.count {
            if wordList[idx] == stopWords[j] {
                isStop = true
                break
            }
            j += 1
        }
        if !isStop {
            result.append(wordList[idx])
        }
        idx += 1
    }
    return result
}

// 5. Frequencies
func frequencies(_ words: [String]) -> [[String]] {
    var wordFreqs: [[String]] = []
    var i = 0
    while i < words.count {
        let word = words[i]
        var found = false
        var j = 0
        while j < wordFreqs.count {
            if wordFreqs[j][0] == word {
                wordFreqs[j][1] = String(Int(wordFreqs[j][1])! + 1)
                found = true
                break
            }
            j += 1
        }
        if !found {
            wordFreqs.append([word, "1"])
        }
        i += 1
    }
    return wordFreqs
}

// 6. Sort by frequency (manual bubble sort)
func sort(_ wordFreqs: [[String]]) -> [[String]] {
    var freqs = wordFreqs
    var i = 0
    while i < freqs.count {
        var j = i + 1
        while j < freqs.count {
            if Int(freqs[j][1])! > Int(freqs[i][1])! {
                let temp = freqs[i]
                freqs[i] = freqs[j]
                freqs[j] = temp
            }
            j += 1
        }
        i += 1
    }
    return freqs
}

// 7. Print recursively
func printAll(_ freqs: [[String]], _ index: Int = 0, _ limit: Int = 25) {
    if index < freqs.count && index < limit {
        print("\(freqs[index][0]) - \(freqs[index][1])")
        printAll(freqs, index + 1, limit)
    }
}

// MARK: - Main Pipeline

if CommandLine.arguments.count < 2 {
    print("Usage: swift Week6_exercise.swift <input_file>")
    exit(1)
}

let inputPath = CommandLine.arguments[1]

// The full pipeline
printAll(sort(frequencies(removeStopWords(scan(filterCharsAndNormalize(readFile(inputPath)))))))
