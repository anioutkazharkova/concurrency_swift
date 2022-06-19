## Load images

### Load task
```
   func loadImage(url: String, completion: @escaping (Data?) -> Void) {
        if let url = URL(string: url) {
            let task = Task.detached { [weak self] in
                let image =  try await self?.downloadImage(url: url)
            }
        }
    }
    ```

### Task group
```
    @MainActor
    private func loadImages() {
        let loadTask = Task { [weak self] in
            guard let self = self else {return}
            if let cats = try? await TaskSyncNetworkClient().loadUserImages(forURLs: CatsKeeper.cats) {
                self.adapter?.setupImages(images: cats.map{$0 == nil ? UIImage() : $0!})
                self.imagesList?.reloadData()
            }
            
        }
    }
    ```
### Async-await array
```    
    @MainActor
    func notRecommendedLoad()  {
        let imagesUrl = CatsKeeper.cats.map{URL(string: $0)}.compactMap{$0}
        Task {
            let image1 = try? await downloadImage(url: imagesUrl[0])
            let image2 = try? await downloadImage(url: imagesUrl[1])
            let image3 = try? await downloadImage(url: imagesUrl[2])
            let image4 = try? await downloadImage(url: imagesUrl[3])
            let image5 = try? await downloadImage(url: imagesUrl[4])
            self.adapter?.setupImages(images: [image1,image2,image3,image4,image5].map{$0 == nil ? UIImage() : $0!})
            self.imagesList?.reloadData()
        }
    }
  ```
### Async - let   
  ```  
    @MainActor
    func recommendedLoad()  {
        let imagesUrl = CatsKeeper.cats.map{URL(string: $0)}.compactMap{$0}
        Task {
          /* async let image1 = downloadImage(url: imagesUrl[0])
           async let image2 = downloadImage(url: imagesUrl[1])
           async let image3 = downloadImage(url: imagesUrl[2])
           async let image4 = downloadImage(url: imagesUrl[3])
           async let image5 = downloadImage(url: imagesUrl[4])
            let images = (try? await [image1,image2,image3,image4,image5]) ?? [UIImage?]()*/
          /*  var images = [Task<UIImage?,Never>]()
            for imageUrl in imagesUrl {
                async let im = downloadImage(url: imageUrl)
                images.append(im)
            }*/
           // self.adapter?.setupImages(images: images.map{$0 == nil ? UIImage() : $0!})
            self.imagesList?.reloadData()
        }
    }
```
