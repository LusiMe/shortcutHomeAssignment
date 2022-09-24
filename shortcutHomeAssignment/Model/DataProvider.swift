
import Foundation
import UIKit

protocol DataProvider {
    
    func getData(for number: Int?) async throws -> ComicPresent
    }
