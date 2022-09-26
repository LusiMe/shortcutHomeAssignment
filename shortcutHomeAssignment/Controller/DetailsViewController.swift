import UIKit

class DetailsViewController: UIViewController {
    var name = String()
    var date = String()
    var details = String()
    
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicDate: UILabel!
    @IBOutlet weak var comicDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicDetails?.text = details
        comicDate?.text = date
        comicTitle?.text = name
    }
    
}
