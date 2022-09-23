
import Foundation
import UIKit

protocol DataProvider {
    
    func getData() async throws -> UIImage
    }
