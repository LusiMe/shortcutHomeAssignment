
import Foundation
import UIKit

class Network {
    
    private let BASE_URL = "https://xkcd.com/"
    
    private let EXPLANATION_URL = "https://www.explainxkcd.com/wiki/api.php"
//    ?action=parse&page=2172:_Lunar_Cycles&prop=text&sectiontitle=Explanation&format=json"
    
    enum methods {
        static let get = "GET"
    }
    
    private func fetchComic(for number: Int?) async throws -> ComicPresent {
        var fullUrl = String()
        if number != nil {
            fullUrl = "\(BASE_URL)\(number!)/info.0.json"
        } else {
            fullUrl = "\(BASE_URL)info.0.json"
        }
        let urlBuilder = URLComponents(string: fullUrl)
        
        guard let url = urlBuilder?.url else { throw NetworkError.transportError }
        
        var request = URLRequest(url: url)
        request.httpMethod = methods.get
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponce = response as? HTTPURLResponse,
              httpResponce.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        print("DATA", data)
        
        let comic = try JSONDecoder().decode(Comic.self, from: data)
        let comicUrl = URL(string: comic.img)
        let image = try await fetchImage(url: comicUrl!)
        let comicPresent = ComicPresent(image: image, comicDetails: comic)
        return comicPresent
    }
    
    func fetchImage(url:URL) async throws -> UIImage {
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = responce as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.decodingError
        }
        return image
    }
    
    func getExplanation(for comicNumber: Int, comicTitle: String) async throws -> String {
        let comicTitle = comicTitle.replacingOccurrences(of: " ", with: "_")
        var urlBuilder = URLComponents(string: EXPLANATION_URL)
        urlBuilder?.queryItems = [
        URLQueryItem(name: "action", value: "parse"),
        URLQueryItem(name: "page", value: "\(comicNumber):_\(comicTitle)"),
        URLQueryItem(name: "prop", value: "text"),
        URLQueryItem(name: "sectiontitle", value: "Explanation"),
        URLQueryItem(name: "format", value: "json")]
        
        guard let url = urlBuilder?.url else { throw NetworkError.transportError }
        
        var request = URLRequest(url: url)
        request.httpMethod = methods.get
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponce = response as? HTTPURLResponse,
              httpResponce.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        print("DATA", data)
        
        let comicExplanation = try JSONDecoder().decode(ComicExplanation.self, from: data)
        let text = comicExplanation.parse.text.explanation
        
        print(ParseHelper.parseComicExplanation(for: text))
        return ParseHelper.parseComicExplanation(for: text)
    }
}

extension Network: DataProvider {

    func getData(for number: Int?) async throws -> ComicPresent {
        let comic = try await fetchComic(for: number)
        return comic
    }

    func getComicExplanation(for comicNumber: Int, comicTitle: String) async throws -> String {
        let comicExplanation = try await getExplanation(for: comicNumber, comicTitle: comicTitle)
        return comicExplanation
    }
}
