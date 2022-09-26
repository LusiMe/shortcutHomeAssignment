import UIKit

class ComicViewController: UIViewController {
    var data = Network(httpSession: HttpRequest())
    var comic = ComicPresent(image: nil, comicDetails: nil)
    var comicExplanation = String()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var presentDescription: UIButton!
    @IBOutlet weak var presentExplanation: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        Task {
            do {
                comic = try await data.getComic(comicNumber: nil as Int?)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("get data issues")
            }
        }
    }
    
    //
    // MARK: - View Controller
    //
    @IBAction func presentDetails(_ sender: UIButton) {
        if let comicDetails = comic.comicDetails {
            let comicTitle = comicDetails.title
            let comicTranscript = comicDetails.transcript
            let date = "\(comicDetails.year).\(comicDetails.month)"
            
            DispatchQueue.main.async {
                let detailsVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(identifier: "detailsViewController")
                as? DetailsViewController
                detailsVC?.name = comicTitle
                detailsVC?.date = date
                detailsVC?.details = comicTranscript.isEmpty
                    ?  comicDetails.alt
                    : comicTranscript
                self.present(detailsVC!, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func presentExplanation(_ sender: UIButton) {
        let explanationVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "explanationViewController")
        as? ExplanationViewController
        if let comicNumber = comic.comicDetails?.num,
           let comicTitle = comic.comicDetails?.title {
            Task {
                do {
                    comicExplanation = try await data.getComicExplanation(comicNumber: comicNumber, comicTitle: comicTitle)
                    explanationVC!.explanation = comicExplanation
                    DispatchQueue.main.async {
                        self.present(explanationVC!, animated: true, completion: nil)
                    }
                } catch {
                    print("get data issues", error)
                }
            }
        }
    }
}

extension ComicViewController: UICollectionViewDelegate {
    
}
//
// MARK: - Table View Data Source
//
extension ComicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as? ComicCollectionViewCell
        if comic.image != nil {
            comicCollectionCell!.comicImage.image = comic.image
        }
        return comicCollectionCell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var comicNumber = Int()
        if comic.comicDetails?.num != nil {
            let isScrollingForward = scrollView
                .panGestureRecognizer
                .translation(in: self.collectionView.superview)
                .x > 0
            if isScrollingForward {
                comicNumber = comic.comicDetails!.num + 1
            } else {
                comicNumber = comic.comicDetails!.num - 1
            }
        }
        
        Task {
            do {
                comic = try await data.getComic(comicNumber: comicNumber)
                collectionView.reloadData()
            } catch {
                print("SCROLL FETCH ISSUES", error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
}

//
// MARK: Search Bar Delegate
//

extension ComicViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard (searchBar.text?.isEmpty) != nil else {
            print("empty search bar")
            return
        }
        if searchBar.text!.isInt {
            let searchDigit = Int(searchBar.text!)
            Task {
                do {
                    comic = try await data.getComic(comicNumber: searchDigit)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("get data issues", error)
                }
            }
        } else {
            let searchTitle = searchBar.text
            Task {
                do {
                    comic = try await data.postSearchTitle(title: searchTitle!)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("get data issues", error.localizedDescription)
                }
            }
        }
    }
}
