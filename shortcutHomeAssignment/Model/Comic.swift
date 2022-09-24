
import Foundation
import UIKit

struct Comic: Codable {
   var title, alt, img: String
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
