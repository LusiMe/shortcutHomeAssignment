
import UIKit

class ViewController: UIViewController {
    
    var data = Network()
    
    var comic = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataManager = DataManager(data: data)
        print("dataManager", dataManager)
        Task {
            do {
                print("await comic")
                comic = try await data.getData()
                print("comic", comic)
            } catch {
                print("get data issues")
            }
        }
    }


}

