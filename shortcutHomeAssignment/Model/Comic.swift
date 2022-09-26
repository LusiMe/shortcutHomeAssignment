import Foundation
import UIKit

struct Comic: Codable {
    var title, alt, year, month, transcript, img: String
    var num: Int
}

struct ComicPresent {
    var image: UIImage?
    var comicDetails: Comic?
}

struct ComicExplanation: Codable {
    var parse: Wikitext
}

struct Wikitext: Codable {
    var text: Explanation
}

struct Explanation: Codable {
    var explanation: String
    enum CodingKeys: String, CodingKey {
        case explanation = "*"
    }
}

struct TextSearchResult: Codable {
    var results: [Hits]
    func convertToComic() -> Comic {
        let data = self.results[0].hits[0].document
        return Comic(
            title: data.title,
            alt: data.altTitle,
            year: String(data.publishDateYear),
            month: String(data.publishDateMonth),
            transcript: data.altTitle,
            img: data.imageUrl,
            num: Int(data.id)!
        )
    }
}

struct Hits: Codable {
    var hits: [Documents]
}

struct Documents: Codable {
    var document: Document
}

struct Document: Codable {
    var imageUrl, id, title, altTitle: String
    var publishDateMonth, publishDateYear: Int
}
