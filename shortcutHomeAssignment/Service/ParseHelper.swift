
import Foundation

class ParseHelper {
    static func parseComicExplanation(for text: String) -> String {
        let formatedText = text.htmlToString
        print(formatedText)
        let explanation = formatedText.split(separator: "Explanation[edit]")[1]
        let cutTranscript = explanation.split(separator: "Transcript")[0]
        return String(cutTranscript)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var isInt: Bool {
            return Int(self) != nil
        }
    }

