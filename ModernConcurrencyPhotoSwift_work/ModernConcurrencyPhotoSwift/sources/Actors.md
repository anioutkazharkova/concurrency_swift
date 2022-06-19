##  Actors
```
actor ImageDownloader {
    private enum ImageStatus {
        case downloading(_ task: Task<UIImage?, Error>)
        case downloaded(_ image: UIImage?)
    }
    
    private var cache: [URL: ImageStatus] = [:]
    
    func image(from url: URL) async throws -> UIImage? {
        if let imageStatus = cache[url] {
            switch imageStatus {
            case .downloading(let task):
                return try await task.value
            case .downloaded(let image):
                return image
            }
        }
        
        let task = Task.detached { [weak self] in
            (try await self?.downloadImage(url: url))
        }
        
        cache[url] = .downloading(task)
        
        do {
            let image = try await task.value
            cache[url] = .downloaded(image)
            return image
        } catch {
            // If an error occurs, we will evict the URL from the cache
            // and rethrow the original error.
            cache.removeValue(forKey: url)
            throw error
        }
    }
    
    private func downloadImage(url: URL) async throws -> UIImage {
        let imageRequest = URLRequest(url: url)
        let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
        guard let image = UIImage(data: data), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageDownloadError.badImage
        }
        return image
    }
}
```

### Sendable
```

   @Sendable func applyFilter(filterName: String, value: Int = 0) async -> UIImage? {
        return try? await applyProcessing(filterName: filterName, value)
    }
```

### Isolated-nonisolated
```
actor WrongFilterProcessor {
    private var currentImage: UIImage? = nil
    private var currentFilter: CIFilter? = nil
    
    let context: CIContext = CIContext()
    
    nonisolated func setup(image: UIImage) {
        Task{[weak self] in
            await self?.setupImage(image: image)
        }
    }
    nonisolated func setup(filter: String) {
        Task { [weak self] in
            await self?.selectFilter(filter: filter)
        }
    }
    
    private func setupImage(image: UIImage) {
        self.currentImage = image
        if let filter = self.currentFilter {
            let beginImage = CIImage(image: image)
            filter.setValue(beginImage, forKey: kCIInputImageKey)
        }
    }
    
    private func selectFilter(filter: String) {
        self.currentFilter = CIFilter(name: filter)
        if let image = self.currentImage {
            let beginImage = CIImage(image: image)
            self.currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        }
    }
    
    func setupParameters(_ baseIntencity: Int = 0) {
        let size = currentImage?.size
        self.currentFilter?.setupParameters(baseIntencity, size)
    }
    
    private func applyProcessing(_ baseIntencity: Int = 0) async throws -> UIImage? {
        self.setupParameters(baseIntencity)
        guard let filter = currentFilter, let outputImage = filter.outputImage else {return nil}
        return await withCheckedContinuation { continuation in
            if let cgimg = context.createCGImage(outputImage, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                continuation.resume(returning: processedImage)
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
    
    nonisolated func applyFilter(value: Int = 0) async -> UIImage? {
        return try? await applyProcessing(value)
    }
}
```

## Group
```actor FilterProcessor {
    private var currentImage: UIImage? = nil
    
    private var processed: [String: UIImage] = [String:UIImage]()
    
    let context: CIContext = CIContext()
    
    init(){}
    
    init(image: UIImage) {
        self.currentImage = image
    }
    
    
    private func applyProcessing(filterName: String, _ baseIntencity: Int = 0) async throws -> UIImage? {
        let filter = CIFilter.create(filterName)
        if let image = self.currentImage {
            filter.setupImage(image: image)
        }
        filter.setupParameters(baseIntencity, self.currentImage?.size)
        guard let outputImage = filter.outputImage else {return nil}
        return await withCheckedContinuation { continuation in
            autoreleasepool {
            if let cgimg = context.createCGImage(outputImage, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgimg)
               // self.addImage(filter: filterName, image: processedImage)
                continuation.resume(returning: processedImage)
            } else {
                continuation.resume(returning: nil)
            }
            }
        }
    }
    
    func addImage(filter: String, image: UIImage) {
        self.processed[filter] = image
    }
    
   @Sendable func applyFilter(filterName: String, value: Int = 0) async -> UIImage? {
        return try? await applyProcessing(filterName: filterName, value)
    }
}
```
