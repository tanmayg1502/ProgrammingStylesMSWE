import Foundation
guard CommandLine.arguments.count>1 else{print("Usage: swift Main.swift <input_file>");exit(1)}
let p=CommandLine.arguments[1];let s=((try?String(contentsOfFile:"../stop_words.txt",encoding:.utf8))?.lowercased().split(separator:",").map{String($0)} ?? [])+(97...122).map{String(UnicodeScalar($0)!)}
var w:[[String]]=[]
(try?String(contentsOfFile:p,encoding:.utf8))?.lowercased().components(separatedBy:CharacterSet.alphanumerics.inverted).filter{!$0.isEmpty && !s.contains($0)}.forEach{x in if let i=w.firstIndex(where:{$0[0]==x}){w[i][1]=String(Int(w[i][1])!+1);var j=i;while j>0 && Int(w[j][1])!>Int(w[j-1][1])!{w.swapAt(j,j-1);j-=1}}else{w.append([x,"1"])}}
w.prefix(25).forEach{print("\($0[0]) - \($0[1])")}