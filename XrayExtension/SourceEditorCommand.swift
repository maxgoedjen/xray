import AppKit
import XcodeKit
import SwiftUI
import XrayKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

    @State var configuration = Configuration()

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        do {
            guard let selections = invocation.buffer.selections as? [XCSourceTextRange],
                  let lines = invocation.buffer.lines as? [String]
                        else { throw CreationError() }
            var allFullTexts: [String] = []
            for selection in selections {
                var fullText = ""
                if selection.start.line == selection.end.line {
                    if selection.start.column == selection.end.column {
                        // No lines selected, append full document
                        fullText.append(invocation.buffer.completeBuffer)
                    } else {
                        fullText.append(lines[selection.start.line][selection.start.column..<selection.end.column])
                    }
                } else {
                    fullText.append(lines[selection.start.line][selection.start.column...])
                    for line in lines[selection.start.line+1..<selection.end.line] {
                        fullText.append(line)
                    }
                    fullText.append(lines[selection.end.line][..<selection.end.column])
                }
                allFullTexts.append(fullText)
            }
            let fullFullText = allFullTexts.joined(separator: "\n")
            try create(snippet: fullFullText)
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
    
}

extension String {

    subscript(_ range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.startIndex)
        let end = index(startIndex, offsetBy: range.endIndex)
        return String(self[start..<end])
    }

    subscript(_ range: PartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        return String(self[start...])
    }

    subscript(_ range: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[..<end])
    }

}

extension SourceEditorCommand {

    func create(snippet: String) throws {
        guard let encoded = snippet.data(using: .utf8)?.base64EncodedString() else { throw CreationError() }
        let urlencoded = encoded.replacingOccurrences(of: "+", with: "%2B")
        var components = URLComponents(string: "https://ray.so")
        components?.queryItems = [
            URLQueryItem(name: "colors", value: configuration.colors.rawValue),
            URLQueryItem(name: "background", value: configuration.background.description),
            URLQueryItem(name: "darkMode", value: configuration.resolvedDarkMode),
            URLQueryItem(name: "padding", value: configuration.padding.rawValue),
        ]
        // QueryItems messes up urlencoded strings.
        guard let partial = components?.url?.absoluteString,
              let url = URL(string: partial + "&code=\(urlencoded)") else { throw CreationError() }
        NSWorkspace.shared.open(url)
    }

}

struct CreationError: Error {
}
