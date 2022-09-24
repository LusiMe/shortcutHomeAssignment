
import UIKit

class ComicViewController: UIViewController {
    
    var data = Network()
    
    var comic = ComicPresent(image: nil, comicDetails: nil)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataManager = DataManager(data: data)
        Task {
            do {
                comic = try await data.getData(for: nil)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("get data issues")
            }
        }
    }
}

extension ComicViewController: UICollectionViewDelegate {
    
}

extension ComicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionViewCell
        if comic.image != nil {
            comicCollectionCell.comicImage.image = comic.image
        }
        return comicCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let comicDetails = comic.comicDetails {
            let comicTitle = comicDetails.title
            let comicTranscript = comicDetails.transcript
            let date = "\(comicDetails.year).\(comicDetails.month)"
            
            DispatchQueue.main.async() {
                let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailsViewController") as? DetailsViewController
                detailsVC?.name = comicTitle
                detailsVC?.date = date
                detailsVC?.details = comicTranscript
                self.present(detailsVC!, animated: true, completion: nil)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var comicNumber = Int()
        
        if comic.comicDetails?.num != nil {
            let isScrollingForward = scrollView.panGestureRecognizer.translation(in: self.collectionView.superview).x > 0
            if isScrollingForward {
                comicNumber = comic.comicDetails!.num + 1
            } else {
                comicNumber = comic.comicDetails!.num - 1
            }
        }
        
        Task {
            do {
                comic = try await data.getData(for: comicNumber)
                collectionView.reloadData()
            } catch {
                print("SCROLL FETCH ISSUES", error.localizedDescription)
            }
        }
    }
    
}
