//
//  ImagePickerController.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ImagePickerVC: BaseVC {
    
    private weak var photoManager = ImagePhotoManager.shared
    var adapter: ImageAdapter?
    
    @IBOutlet weak var imageList: UICollectionView?
    @IBOutlet weak var loader: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter = ImageAdapter()
        adapter?.sideSize = ((self.view?.bounds.width ?? 0) - 8.0)/4
        
        imageList?.register(UINib.init(nibName: ImagePickerCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ImagePickerCell.cellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adapter?.owner = self
        self.adapter?.photoHolder = photoManager
        imageList?.delegate = adapter
        imageList?.dataSource = adapter
        loadAssets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.adapter?.owner = nil
        self.adapter?.photoHolder = nil
        imageList?.delegate = nil
        imageList?.dataSource = nil
        imageList?.reloadData()
        super.viewWillDisappear(animated)
    }
    
    func loadAssets(_ completion: (()->())? = nil) {
        self.showLoading(show: true)
        ImagePhotoManager.shared.loadAssets(success: {
            [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.imageList?.reloadData()
                self?.showLoading(show: false)
                self?.imageList?.isHidden = false
                completion?()
            }
            }, failure: { [weak self] in
                self?.showLoading(show: false)
                self?.showNeedAccessMessage()
        })
    }
    
    func showNeedAccessMessage() {
        let alert = UIAlertController(title: nil, message: "Приложению необходим доступ к фотографиям", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        
        show(alert, sender: nil)
    }
    
    
    @IBAction func takePhotoClicked(_ sender: Any) {
        self.takePhoto()
    }
    
    private func loadImage(index: Int) {
        photoManager?.selectAsset(index: index)
        goToFilter()
    }
    
    private func goToFilter() {
        let vc = ImageSettingsVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showLoading(show: Bool) {
        if (show) {
            self.loader?.startAnimating()
        } else {
            self.loader?.stopAnimating()
        }
        self.loader?.isHidden = !show
    }
}

extension ImagePickerVC: ListOwner {
    
    func reload() {
        imageList?.reloadData()
    }
    
    func selectedItem(index: Int) {
        self.loadImage(index: index)
    }
}

extension ImagePickerVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        photoManager?.saveImage(image: image, successful: { [weak self] in
            self?.loadAssets{
                [weak self] in
                self?.selectedItem(index: 0)
            }
            self?.dismiss(animated:true, completion: nil)
        }, failure: { [weak self] in
            self?.dismiss(animated:true, completion: nil)
        })
        }
    }
}
