
import Foundation
import UIKit

struct Comic: Codable {
   var title, alt, year, month, transcript, img: String
    var num: Int
}

struct ComicPresent {
    var image: UIImage?
    var comicDetails: Comic?
    
//    init(img: UIImage, comic: Comic) {
//        self.image = img
//        self.comicDetails = comic
//    }
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


