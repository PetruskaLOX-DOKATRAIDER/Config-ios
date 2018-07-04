//
//  GradientButton.swift
//  Core
//
//  Created by Oleg Petrychuk on 20.06.2018.
//  Copyright © 2018 Oleg Petrychuk. All rights reserved.
//

import DTCollectionViewManager
import DTModelStorage

class PinterestLayout: UICollectionViewLayout {
    private let numberOfColumns: Int
    private let cellPadding: CGFloat
    private let collectionViewManager: DTCollectionViewManager
    private var contentHeight: CGFloat = 0
    private var cache = [UICollectionViewLayoutAttributes]()
    override var collectionViewContentSize: CGSize { return CGSize(width: contentWidth, height: contentHeight) }
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    public init(numberOfColumns: Int = 3, cellPadding: CGFloat = 4, collectionViewManager: DTCollectionViewManager) {
        self.numberOfColumns = numberOfColumns
        self.cellPadding = cellPadding
        self.collectionViewManager = collectionViewManager
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        for item in 0 ..< Int(self.collectionViewManager.memoryStorage.items(inSection: 0)?.count ?? 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = collectionViewManager.collectionDelegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath).height ?? 0
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        cache.forEach{
            if $0.frame.intersects(rect) {
                visibleLayoutAttributes.append($0)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
