
import Foundation
import UIKit

class Network {
    
    private let BASE_URL = "https://xkcd.com/"
    
    private let EXPLANATION_URL = "https://www.explainxkcd.com/wiki/api.php"
    
    private let SEARCH_BY_TITLE_URL = "https://qtg5aekc2iosjh93p.a1.typesense.net/multi_search"
    
    enum methods {
        static let get = "GET"
        static let post = "POST"
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
    
    private func searchComicByTitle(title: String) async throws -> ComicPresent {
        let jsonBody: Dictionary<String, Any> = [
            "searches": [[
                "query_by": "title,altTitle,transcript,topics",
                "query_by_weights": "127,80,80,1",
                "drop_tokens_threshold": 2,
                "typo_tokens_threshold": 0,
                "num_typos": 1,
                "sort_by": "",
                "highlight_full_fields": "title,altTitle,transcript,topics",
                "collection": "xkcd",
                "q": "\(title)",
                "facet_by": "topics,publishDateYear",
                "filter_by": "",
                "max_facet_values": 100,
                "page": 1,
                "per_page": 5
            ]]
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        var urlBuilder = URLComponents(string: SEARCH_BY_TITLE_URL)
        urlBuilder?.queryItems = [
            URLQueryItem(name: "use_cache", value: "true"),
            URLQueryItem(name: "x-typesense-api-key", value: "8hLCPSQTYcBuK29zY5q6Xhin7ONxHy99")
            ]
        guard let url = urlBuilder?.url else { throw NetworkError.transportError }
        var request = URLRequest(url: url)
        request.httpMethod = methods.post
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)
    
        guard let httpResponce = response as? HTTPURLResponse,
              httpResponce.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        print(data)
        let comic = try JSONDecoder().decode(TextSearchResult.self, from: data)
        let comicDocument = comic.results[0].hits[0].document
        let comics = Comic(title: comicDocument.title, alt: comicDocument.altTitle, year: "\(comicDocument.publishDateYear)", month: "\(comicDocument.publishDateMonth)", transcript: comicDocument.altTitle, img: comicDocument.imageUrl, num: Int(comicDocument.id)!)
        let comicUrl = URL(string: comicDocument.imageUrl)
        let image = try await fetchImage(url: comicUrl!)
        let comicPresent = ComicPresent(image: image, comicDetails: comics)
        return comicPresent
        
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
    
    func postSearchTitle(title: String) async throws-> ComicPresent {
        let searchResult = try await searchComicByTitle(title: title)
        return searchResult
    }
}
