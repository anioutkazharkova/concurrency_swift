##  Apply filter manager

### Filter images with actor
```
    @MainActor
    func getImages(intensity: Int = 0) {
        Task { [weak self] in
            guard let self = self else {return}
            let images = await self.filterManager.prepareImages(intensity)
            self.previewAdapter.setupItems(items: images)
            self.previewList.reloadData()
        }
    }
```
### Complicated actor
```    
    @MainActor
    func getImagesGroup(intensity: Int = 0) {
        Task { [weak self] in
            guard let self = self else {return}
            let images = await self.filterGroupManager.prepareImages(intensity)
            self.previewAdapter.setupItems(items: images)
            self.previewList.reloadData()
        }
    }
 ```
 ### GCD
 ```   
    private func getImagesCGD(intencity: Int = 0) {
        filterGCDManager.prepareImages(intencity) { [weak self] images in
            guard let self = self else {return}
            self.previewAdapter.setupItems(items: images.map{$0 == nil ? UIImage() : $0!})
            self.previewList.reloadData()
        }
    }
``
