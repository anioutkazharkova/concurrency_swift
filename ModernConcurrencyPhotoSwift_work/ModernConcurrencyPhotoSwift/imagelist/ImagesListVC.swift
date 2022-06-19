//
//  ImagesListVC.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 13.06.2022.
//

import UIKit

class ImagesListVC: UIViewController {
    private lazy var adapter: ImageListAdapter? = {
       return ImageListAdapter()
    }()
    
    lazy var client: TaskNetworkClient = {
       return TaskNetworkClient()
    }()

    @IBOutlet weak var imagesList: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter?.sideSize = ((self.view?.bounds.width ?? 0) - 8.0)/2
        
        imagesList?.register(UINib.init(nibName: ImagePickerCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ImagePickerCell.cellIdentifier)
        imagesList.dataSource = adapter
        imagesList.delegate = adapter
        adapter?.owner = self
        
        //Loading
        //loadDefault()
       // self.recommendedLoad()
        self.loadImages()
    }
    
    @MainActor
    func loadImages() {
        Task {
          let images = (try?  await client.loadUserImages(forURLs:CatsKeeper.cats)) ?? []
            self.adapter?.setupImages(images: images.map{$0 == nil ? UIImage() : $0!})
            self.imagesList?.reloadData()
        }
    }
    
    @MainActor
    func notRecommendedLoad()  {
        let imagesUrl = CatsKeeper.cats.map{URL(string: $0)}.compactMap{$0}
        Task {
            let image1 = try? await client.downloadImage(url: imagesUrl[0])
            let image2 = try? await client.downloadImage(url: imagesUrl[1])
            let image3 = try? await client.downloadImage(url: imagesUrl[2])
            let image4 = try? await client.downloadImage(url: imagesUrl[3])
            let image5 = try? await client.downloadImage(url: imagesUrl[4])
            self.adapter?.setupImages(images: [image1,image2,image3,image4,image5].map{$0 == nil ? UIImage() : $0!})
            self.imagesList?.reloadData()
        }
    }
    
    @MainActor
    func recommendedLoad()  {
        let imagesUrl = CatsKeeper.cats.map{URL(string: $0)}.compactMap{$0}
        Task {
            async let image1 = try? client.downloadImage(url: imagesUrl[0])
            async let image2 = try? client.downloadImage(url: imagesUrl[1])
            async let image3 = try? client.downloadImage(url: imagesUrl[2])
            async let image4 = try? client.downloadImage(url: imagesUrl[3])
            async let image5 = try? client.downloadImage(url: imagesUrl[4])
            let images = await [image1,image2,image3,image4,image5]
           // let tasks = [image1,image2,image3,image4,image5]
            self.adapter?.setupImages(images: images.map{$0 == nil ? UIImage() : $0!})
            self.imagesList?.reloadData()
        }
    }
    
    /*private func loadDefault() {
        GCDNetworkClient().images(forURLs: CatsKeeper.cats) { [weak self] data in
            guard let self = self else {return}
            let images = data.map{$0 == nil ? UIImage() : UIImage(data: $0!) ?? UIImage()}
            self.adapter?.setupImages(images: images)
            self.imagesList?.reloadData()
        }
                                    
    }*/

   
}

extension ImagesListVC : ListOwner {
    func reload() {
        
    }
    
    
    func selectedItem(index: Int) {
        if let image = self.adapter?.images[index] {
            goToFilter(image: image)
        }
    }
    
    private func goToFilter(image: UIImage) {
        let vc = ImageSettingsVC()
        vc.defaultImage = image
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
