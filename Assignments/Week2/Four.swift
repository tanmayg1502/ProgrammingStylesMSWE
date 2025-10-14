import Foundation

// MARK: - Helper Functions

// Convert uppercase A–Z to lowercase manually
func toLower(_ c: Character) -> Character {
    if let ascii = c.asciiValue, ascii >= 65 && ascii <= 90 {
        return Character(UnicodeScalar(ascii + 32))
    }
    return c
}

// Check if character is alphanumeric manually
func isAlnum(_ c: Character) -> Bool {
    if let ascii = c.asciiValue {
        return (ascii >= 48 && ascii <= 57) || (ascii >= 65 && ascii <= 90) || (ascii >= 97 && ascii <= 122)
    }
    return false
}

// Read a file line by line manually
func readFileLines(_ path: String) -> [String] {
    guard let data = FileManager.default.contents(atPath: path) else { return [] }
    var lines: [String] = []
    var current = ""
    for byte in data {
        let c = Character(UnicodeScalar(byte))
        if c == "\n" {
            lines.append(current)
            current = ""
        } else if c != "\r" {
            current.append(c)
        }
    }
    if !current.isEmpty {
        lines.append(current)
    }
    return lines
}

// Check if a word is in the stop words list manually
func isStopWord(_ word: String, _ stopWords: [String]) -> Bool {
    var i = 0
    while i < stopWords.count {
        if stopWords[i] == word {
            return true
        }
        i += 1
    }
    return false
}

// MARK: - Main Program

if CommandLine.arguments.count < 2 {
    print("Usage: swift Main.swift <input_file>")
    exit(1)
}

let inputPath = CommandLine.arguments[1]

// Read stop words manually
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
            current.append(toLower(c))
        }
    }
    if current != "" {
        stopWords.append(current)
    }
}

// Add single letters a–z to stop words
var i = 97
while i <= 122 {
    stopWords.append(String(UnicodeScalar(i)!))
    i += 1
}

// Global list of [word, freq]
var wordFreqs: [[String]] = []

let lines = readFileLines(inputPath)

var lineIndex = 0
while lineIndex < lines.count {
    let line = lines[lineIndex]
    let chars = Array(line)
    var startChar: Int? = nil
    var i = 0

    while i < chars.count {
        let c = chars[i]

        if startChar == nil {
            if isAlnum(c) {
                startChar = i
            }
        } else {
            if !isAlnum(c) {
                // End of word
                var word = ""
                var j = startChar!
                while j < i {
                    word.append(toLower(chars[j]))
                    j += 1
                }

                if !isStopWord(word, stopWords) {
                    var found = false
                    var pairIndex = 0
                    var k = 0
                    while k < wordFreqs.count {
                        if wordFreqs[k][0] == word {
                            let count = Int(wordFreqs[k][1])! + 1
                            wordFreqs[k][1] = String(count)
                            found = true
                            pairIndex = k
                            break
                        }
                        k += 1
                    }

                    if !found {
                        wordFreqs.append([word, "1"])
                        pairIndex = wordFreqs.count - 1
                    } else if wordFreqs.count > 1 {
                        var n = pairIndex - 1
                        while n >= 0 {
                            let curr = Int(wordFreqs[pairIndex][1])!
                            let prev = Int(wordFreqs[n][1])!
                            if curr > prev {
                                let temp = wordFreqs[n]
                                wordFreqs[n] = wordFreqs[pairIndex]
                                wordFreqs[pairIndex] = temp
                                pairIndex = n
                            }
                            n -= 1
                        }
                    }
                }
                startChar = nil
            }
        }
        i += 1
    }

    // Handle last word of line
    if let start = startChar {
        var word = ""
        var j = start
        while j < chars.count {
            word.append(toLower(chars[j]))
            j += 1
        }

        if !isStopWord(word, stopWords) {
            var found = false
            var pairIndex = 0
            var k = 0
            while k < wordFreqs.count {
                if wordFreqs[k][0] == word {
                    let count = Int(wordFreqs[k][1])! + 1
                    wordFreqs[k][1] = String(count)
                    found = true
                    pairIndex = k
                    break
                }
                k += 1
            }

            if !found {
                wordFreqs.append([word, "1"])
                pairIndex = wordFreqs.count - 1
            } else if wordFreqs.count > 1 {
                var n = pairIndex - 1
                while n >= 0 {
                    let curr = Int(wordFreqs[pairIndex][1])!
                    let prev = Int(wordFreqs[n][1])!
                    if curr > prev {
                        let temp = wordFreqs[n]
                        wordFreqs[n] = wordFreqs[pairIndex]
                        wordFreqs[pairIndex] = temp
                        pairIndex = n
                    }
                    n -= 1
                }
            }
        }
    }

    lineIndex += 1
}

// Print top 25
var count = 0
while count < 25 && count < wordFreqs.count {
    print("\(wordFreqs[count][0]) - \(wordFreqs[count][1])")
    count += 1
}
