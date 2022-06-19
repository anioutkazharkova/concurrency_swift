##  Isolated

### Wrong

  ```  
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
```
