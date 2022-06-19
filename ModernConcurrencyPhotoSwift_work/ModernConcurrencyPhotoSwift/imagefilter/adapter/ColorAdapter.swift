//
//  ColorAdapter.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ColorAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var owner: ListOwner?
    private var items = [ColorItem]()

    func setupData(items: [ColorItem]) {
        self.items = [ColorItem]()
        self.items.append(contentsOf: items)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.cellIdentifier,
                                                            for: indexPath) as? ColorCell else {
                                                                return UICollectionViewCell()
        }

        cell.setupData(colorItem: items[indexPath.row])

        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        resetSelected(index: indexPath.row)
        owner?.selectedItem(index: indexPath.row)
    }

    func resetSelected(index: Int) {
        for i in 0..<items.count {
            items[i].isSelected = i == index
        }
        owner?.reload()
    }
}
