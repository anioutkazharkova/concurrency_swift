#  GCD

### Load with queue 
```
    func loadImage(url: String, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            var image: Data?
            if let url = URL(string: url) {
                if let data = try? Data(contentsOf: url) {
                    image = data
                }
            }
            DispatchQueue.main.async {
            completion(image)
            }
        }
    }
    ```

### Load in sequence
```
    func loadImages(index: Int, url: [String], completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            var image: Data?
            if let url = URL(string: url[index) {
                if let data = try? Data(contentsOf: url) {
                    image = data
                }
            }
            DispatchQueue.main.async {
            completion(image)
            loadImages(index: index + 1, url: url, completion: completion)
            }
        }
    }
    ```
    
### Load with group
```
    func images(forURLs urls: [String], completion: @escaping ([Data?]) -> Void) {
        let group = DispatchGroup()
        var images: [Data?] = .init(repeating: nil, count: urls.count)
        
        for (index, urlString) in urls.enumerated() {
            group.enter()
            DispatchQueue.global().async {
                var image: Data?
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        image = data
                    }
                }
                images[index] = image
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    ```
    
