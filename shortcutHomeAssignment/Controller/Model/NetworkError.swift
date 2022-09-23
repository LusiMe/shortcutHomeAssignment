
import Foundation

enum NetworkError: Error {
    case transportError
    case serverError
    case noData
    case decodingError
    case encodingError
    case unsupportedImage
}


