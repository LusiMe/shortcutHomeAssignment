
import UIKit

class ExplanationViewController: UIViewController {

    @IBOutlet weak var comicExplanation: UILabel!
    
    var explanation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comicExplanation?.text = explanation
    }
   

}
