
import Foundation
import UIKit

class Network {
    
    private let BASE_URL = "https://xkcd.com/"
    
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
}

extension Network: DataProvider {
        
    func getData(for number: Int?) async throws -> ComicPresent {
        let comic = try await fetchComic(for: number)
        return comic
    }

}
