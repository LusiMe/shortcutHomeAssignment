
import UIKit

class ComicViewController: UIViewController {
    
    var data = Network()
    
    var comic = UIImage()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataManager = DataManager(data: data)
        print("dataManager", dataManager)
        Task {
            do {
                print("await comic")
                comic = try await data.getData()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                print("comic", comic)
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as! ComicCollectionViewCell
        comicCollectionCell.comicImage.image = comic
        return comicCollectionCell
    }
    
    
}

