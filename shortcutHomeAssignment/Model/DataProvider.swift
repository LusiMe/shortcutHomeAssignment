import Foundation
import UIKit

protocol DataProvider {
    func getComic(comicNumber: Int?) async throws -> ComicPresent
    func getComicExplanation(comicNumber: Int, comicTitle: String) async throws -> String
    func postSearchTitle(title: String) async throws -> ComicPresent
}
