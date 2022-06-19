## Tasks

## init
```
let task = Task {
 // Что-то асинхронное
}

let detachedTask = Task.detached(priority: .background) {
// Что-то асинхронное на фоновом потоке
}
```

### With Continuation
``` 
func someAsync() async throws -> Bool {
        return await withCheckedContinuation { continuation in
              continuation.resume(returning: some)
        }
        }```
        
        
### Async let 
// Верно, но не совсем ок
```
func loadImages() {
    Task {
        let firstImage = await loadImage(index: 1)
        let secondImage = await loadImage(index: 2)
        let thirdImage = await loadImage(index: 3)
        let images = [firstImage, secondImage, thirdImage]
    }
}
```

//Верно
```
func loadImages() {
    Task {
        async let firstImage = loadImage(index: 1)
        async let secondImage = loadImage(index: 2)
        async let thirdImage = loadImage(index: 3)
        let images = await [firstImage, secondImage, thirdImage]
    }
}
```


### Task with group
```
    func loadUserImages(forURLs urls: [String]) async throws -> [UIImage?] {

        let userImages: [UIImage?] = try await withThrowingTaskGroup(of: UIImage?.self) {[weak self] group -> [UIImage?] in
            guard let self = self else {return []}
            for urlString in urls {
                group.addTask { [self] in
                    if let url = URL(string: urlString) {
                        return try await self.downloader.image(from: url)
                    }
                    return nil
                }
            }

            var images: [UIImage?] = []
            for try await image in group {
                images.append(image)
            }

            return images
        }

        return userImages
    }
    ```
    
