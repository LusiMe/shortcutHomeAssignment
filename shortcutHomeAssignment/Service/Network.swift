
import Foundation
import UIKit

class Network {
    
    private let BASE_URL = "https://xkcd.com/info.0.json"
    
    enum methods {
        static let get = "GET"
    }
    
    private func fetchComic() async throws -> UIImage {
        let urlBuilder = URLComponents(string: BASE_URL)
        
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
        
        return image
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
    
    func getData() async throws -> UIImage {
        let comic = try await fetchComic()
        return comic
    }
}
