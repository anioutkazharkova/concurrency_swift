//
//  ImageSettingsVC.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ImageSettingsVC: BaseVC {
    //1. Добавить Filter Manager
    private lazy var gcdFilterManager: GCDFilterManager = {
       return GCDFilterManager()
    }()
    private lazy var filterManager: FilterManager = {
       return FilterManager()
    }()
    
    private lazy var filterGroupManager: FilterGroupManager = {
       return FilterGroupManager()
    }()
    
    var showPrevImageButton: ActionImageButton?
    
    var defaultImage: UIImage?
    var processedImage: UIImage?
    let queue = DispatchQueue(label: "image_queue", qos: .userInteractive)
    var imageItem: DispatchWorkItem?
    
    @IBOutlet weak var previewList: UICollectionView!
    private var previewAdapter: ImageHorizontallAdapter = ImageHorizontallAdapter()
    
    @IBOutlet weak var imageView: ImageScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewList?.register(UINib.init(nibName: ImagePickerCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ImagePickerCell.cellIdentifier)

        previewAdapter.owner = self
        previewList.dataSource = previewAdapter
        
        self.setupImage(image: self.defaultImage ?? UIImage())
        filterManager.currentImage = defaultImage!
        filterGroupManager.currentImage = defaultImage!
        //2 Filter image
        //getImagesCGD()
        getImagesGroup()
    }
    
    func setupImage(image: UIImage) {
        self.defaultImage = image.copy() as? UIImage
        self.processedImage=image.copy() as? UIImage
        setupFilters()
    }
    
    func setupFilters() {
        imageView?.setup()
        
        imageView?.imageContentMode = .aspectFit
        imageView?.initialOffset = .center
        imageView?.display(image: defaultImage!)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMenu()
        imageView?.imageScrollViewDelegate = self
    }
    
    func setupMenu() {
        if (showPrevImageButton == nil) {
            showPrevImageButton = ActionImageButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30)))
            showPrevImageButton?.setBackgroundImage(UIImage(named: "prev_image"), for: .normal)
            showPrevImageButton?.listener = self
        }
        
        let prevImage = UIBarButtonItem(customView: showPrevImageButton!)
        
        self.navigationItem.leftBarButtonItem = prevImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageView?.imageScrollViewDelegate = nil
        self.clean()
        super.viewWillDisappear(animated)
    }
    
 
 
   
    
    @IBAction func intencityChanged(_ sender: Any) {
        let sense = ((sender as? UISlider)?.value ?? 15.0)/100.0 * 5
        //2 Filter image
        //getImagesCGD(intencity: Int(sense))
        getImagesGroup(intencity: Int(sense))
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.clean()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func okClicked(_ sender: Any) {
    }
    
    //2 Filter image
    private func getImagesCGD(intencity: Int = 0) {
       gcdFilterManager.prepareImages(intencity) { [weak self] images in
            guard let self = self else {return}
            self.previewAdapter.setupItems(items: images.map{$0 == nil ? UIImage() : $0!})
            self.previewList.reloadData()
        }
    }
    
    @MainActor
    private func getImages(intencity: Int = 0) {
        Task {
        let images = await filterManager.prepareImages(intencity)
            self.previewAdapter.setupItems(items: images.map{$0 == nil ? UIImage() : $0})
            self.previewList.reloadData()
        }
    }
   
    @MainActor
    private func getImagesGroup(intencity: Int = 0) {
        Task {
        let images = await filterGroupManager.prepareImages(intencity)
            self.previewAdapter.setupItems(items: images.map{$0 == nil ? UIImage() : $0})
            self.previewList.reloadData()
        }
    }
    
    func showDefaultImage() {
        if let image = self.defaultImage {
            self.imageView?.display(image: image)
        }
    }
    
    func showProcessedImage() {
        if let image = self.processedImage {
            self.imageView?.display(image: image)
        }
    }
    
    func clean() {
        self.defaultImage = nil
        self.processedImage = nil
        if (imageItem != nil) {
            imageItem?.cancel()
            imageItem = nil
        }
    }
}

extension ImageSettingsVC: LongPressListener {
    func longPressStarted() {
        showDefaultImage()
    }
    
    func longPressEnded() {
        showProcessedImage()
    }
}

extension ImageSettingsVC: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {}
}

extension ImageSettingsVC : ListOwner {
    func reload() {
        
    }
    
    func selectedItem(index: Int) {
        self.imageView?.image = self.previewAdapter.images[index].copy() as! UIImage
        self.processedImage = self.previewAdapter.images[index].copy() as! UIImage
    }
}
