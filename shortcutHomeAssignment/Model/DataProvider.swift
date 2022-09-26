
import Foundation
import UIKit

protocol DataProvider {
    
    func getData(for number: Int?) async throws -> ComicPresent
    
    func getComicExplanation(for comicNumber: Int, comicTitle: String) async throws -> String
    
    func postSearchTitle(title: String) async throws -> ComicPresent
}
