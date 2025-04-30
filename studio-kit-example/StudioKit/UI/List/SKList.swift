import UIKit

class SKList: UIView {
    
    weak var delegate: SKListDelegate?
    
    var sections: [SKListSection] = []
    var collectionView: UICollectionView!
    var itemHeight: CGFloat = 80
    var itemGap: CGFloat = 10
    var layout: UICollectionViewLayout?
    var selectedIds: [String] = []
    var scrollY: CGFloat?
    var isDragging: Bool?
    var isScrolling: Bool = false
    var cellsToRegister: [SKListCell.Type]?
    var headersToRegister: [SKListHeader.Type]?
    var onItemPress: ((_ item: SKListCell, _ atIndexPath: IndexPath) -> Void)?
    var reuseIdentifierForIndexPath: ((_ atIndexPath: IndexPath) -> String)?
    var headerReuseIdentifierForSection: ((_ section: Int) -> String)?
    var configureCellForIndexPath: ((_ cell: SKListCell, _ indexPath: IndexPath) -> Void)?
    var onCellTap: ((_ event: SKCellTapEvent) -> Void)?
    var onCellSelected: ((_ event: SKCellSelectedEvent) -> Void)?
    var onCellDeselected: ((_ event: SKCellDeselectedEvent) -> Void)?
    var onScroll: ((_ event: SKListScrollEvent) -> Void)?
    
    
    init(
        registerCells: [SKListCell.Type]? = [],
        registerHeaderCells: [SKListHeader.Type]? = [],
        sections: [SKListSection]
    ) {
        super.init(frame: .zero)
        self.cellsToRegister = registerCells
        self.headersToRegister = registerHeaderCells
        self.sections = sections
        
        let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return sections[safe: sectionIndex]?.layout ?? SKList.createGridSection(width: self.frame.width)
        }
        
        layout = compositionalLayout
        
        setupViews()
        
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func refreshData() {
        for (sectionIndex, _) in sections.enumerated() {
            if let scrollCell = collectionView.cellForItem(at: IndexPath(row: 0, section: sectionIndex)) as? SKHorizontalScrollListCell {
                scrollCell.collectionView.reloadData()
            }
        }
        
        collectionView.reloadData()
    }
    
    func getSection(_ sectionId: String) -> SKListSection? {
        if let index = self.sections.firstIndex(where: { $0.id == sectionId }) {
            return self.sections[index]
        }
        return nil
    }
    
    func refreshSection(_ section: Int) {
        if self.sections.indices.contains(section) {
            
            // Check for horizontal cell
            if sections[section].layout?.identifier == "HorizontalScrolling" {
                if let horizontalScrollCell = collectionView.cellForItem(at: IndexPath(row: 0, section: section)) as? SKHorizontalScrollListCell {
                    UIView.performWithoutAnimation {
                        horizontalScrollCell.collectionView.reloadSections(IndexSet(integer: 0))
                    }
                }
            }
            
            UIView.performWithoutAnimation {
                collectionView.reloadSections(IndexSet(integer: section))
            }
        }
    }
    
    func refreshSection(_ sectionId: String) {
        if let index = self.sections.firstIndex(where: { $0.id == sectionId }) {
            refreshSection(index)
        }
    }
    
    func updateSectionItems(_ section: Int, items: [SKListItemData]) {
        if self.sections.indices.contains(section) {
            self.sections[section].items = items
            
            // Update horizontal scroll container
            if sections[section].layout?.identifier == "HorizontalScrolling" {
                if let horizontalScrollCell = collectionView.cellForItem(at: IndexPath(row: 0, section: section)) as? SKHorizontalScrollListCell {
                    horizontalScrollCell.items = items
                }
            }
            
            // Auto hide header and content if count is zero
            if (items.count == 0) {
                let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
                    let layout = self.sections[sectionIndex].layout
                    if (sectionIndex == section) {
                        layout?.contentInsets = .zero
                        layout?.boundarySupplementaryItems = [
                            .init(
                                layoutSize: .init(
                                    widthDimension: .fractionalWidth(1),
                                    heightDimension: .absolute(0)
                                ),
                                elementKind: "Header",
                                alignment: .top
                            )
                        ]
                    }
                    return layout
                }
                collectionView.setCollectionViewLayout(compositionalLayout, animated: false)
            }
        }
    }
    
    func updateSectionItems(_ sectionId: String, items: [SKListItemData]) {
        if let index = self.sections.firstIndex(where: { $0.id == sectionId }) {
            updateSectionItems(index, items: items)
        }
    }
    
    func updateSectionLayout(_ section: Int, layout: SKListLayoutSection) {
        if self.sections.indices.contains(section) {
            self.sections[section].layout = layout
        }
    }
    
    func updateSectionLayout(_ sectionId: String, layout: SKListLayoutSection) {
        if let index = self.sections.firstIndex(where: { $0.id == sectionId }) {
            updateSectionLayout(index, layout: layout)
        }
    }
    
    func refreshLayout() {
        let sections = self.sections
        let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return sections[sectionIndex].layout
        }
        collectionView.setCollectionViewLayout(compositionalLayout, animated: false)
    }
    
    func setIsSelectableForSection(_ sectionId: String, isSelectable: Bool) {
        if let index = self.sections.firstIndex(where: { $0.id == sectionId }) {
            setIsSelectableForSection(index, isSelectable: isSelectable)
        }
    }
    
    func setIsSelectableForSection(_ section: Int, isSelectable: Bool) {
        self.sections[section].isSelectable = isSelectable
        

        for cell in self.collectionView.visibleCells {
            
            guard let indexPath = collectionView.indexPath(for: cell), let cell = cell as? SKListCell else {
                return
            }
            
            if indexPath.section == section {
                let cellData = self.sections[section].items[indexPath.row]
                let id = cellData.id
                
                let isSelected = selectedIds.contains(id ?? "")
                
                if isSelectable {
                    cell.didBecomeSelectable(isSelected: isSelected)
                } else {
                    cell.didBecomeDeselectable()
                }
            }
        }
        
        // This feels a little hacky
        // But it ensures that any cells that are offscreen but not deinit'ed get refreshed
        // AFTER the animations of the visible cells occur
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.350) {
            self.refreshSection(section)
        }
        
        // IDEA: get x number of cells before and after first and last indexpath and also update them
        // Could look something like:
        
        //
        //        let firstVisibleCell = self.collectionView.visibleCells.sorted { (cell1, cell2) -> Bool in
        //            if let indexPath1 = collectionView.indexPath(for: cell1),
        //               let indexPath2 = collectionView.indexPath(for: cell2) {
        //                return indexPath1.row < indexPath2.row
        //            }
        //            return true
        //        }.first
        //
        //        if let firstVisibleCell = firstVisibleCell, let firstVisibleIndexPath = collectionView.indexPath(for: firstVisibleCell) {
        //            let cellData = self.sections[section].items[firstVisibleIndexPath.row]
        //            let id = cellData.id
        //            print(id)
        //        }
      
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let itemWidth = UIScreen.main.bounds.width - 36 // Account for containerView padding
        
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.minimumInteritemSpacing = 10
        defaultLayout.minimumLineSpacing = itemGap
        defaultLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        defaultLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let layout = self.layout ?? defaultLayout
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
       
        // Auto register base cell
        collectionView.register(
            SKListCell.self,
            forCellWithReuseIdentifier: SKListCell.reuseIdentifier
        )
        
        collectionView.register(
            SKHorizontalScrollListCell.self,
            forCellWithReuseIdentifier: SKHorizontalScrollListCell.reuseIdentifier
        )
        
        for cell in (cellsToRegister ?? []) {
            collectionView.register(
                cell.self,
                forCellWithReuseIdentifier: cell.reuseIdentifier
            )
            
            // Auto register placeholder cells
            if let placeholderCell = cell.placeholderCell {
                collectionView.register(placeholderCell.self, forCellWithReuseIdentifier: placeholderCell.reuseIdentifier)
            }
        }
        
        // Auto register base header
        collectionView.register(
            SKListHeader.self,
            forSupplementaryViewOfKind: "Header",
            withReuseIdentifier: SKListHeader.reuseIdentifier
        )
        
//        // Auto register base empty header
//        collectionView.register(
//            SKEmptyListHeader.self,
//            forSupplementaryViewOfKind: "Header",
//            withReuseIdentifier: SKEmptyListHeader.reuseIdentifier
//        )
        
        for headerCell in (headersToRegister ?? []) {
            collectionView.register(
                headerCell.self,
                forSupplementaryViewOfKind: "Header",
                withReuseIdentifier: headerCell.reuseIdentifier
            )
            
        }
        
        collectionView.backgroundColor = .clear
        
        self.addSubview(collectionView)
        self.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
    }
    
    var scrollToDidEnd: (() -> Void)?
    
    func scrollTo(y: CGFloat, completion: (() -> Void)? = nil) {
        scrollToDidEnd = completion
        collectionView.setContentOffset(CGPoint(x: 0, y: y - collectionView.adjustedContentInset.top), animated: true)
    }
    
    func getHeaderForSection(section: Int) -> SKListHeader? {
        if let header = collectionView.supplementaryView(forElementKind: "Header", at: IndexPath(row: 0, section: section)) as? SKListHeader {
            return header
        }
        return nil
    }
    
    func getHeaderForSection(sectionId: String) -> SKListHeader? {
        if let index = self.sections.firstIndex(where: { $0.id == sectionId }) {
            return getHeaderForSection(section: index)
        }
        return nil
    }
    
    static func createDummyData(for rows: Int) -> [SKListItemData] {
        return Array(1...rows).map { _ in
            return SKListDummyData(id: .randomAlphanumericString(length: 10))
        }
    }
    
}

// MARK: scroll view delegate extensions

extension SKList: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
        isScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollToDidEnd?()
        isScrolling = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (isDragging != true) {
            return
        }
        
        if let onScroll = onScroll {
            let previousScrollY = scrollY ?? 0
            let adjustedScrollY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
            onScroll(.init(y: adjustedScrollY, previousY: previousScrollY))
            scrollY = adjustedScrollY
        }
    }
}

// MARK: collection view extensions
extension SKList: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if sections[section].items.count == 0 {
            return 0
        }
        
        return sections[section].layout?.identifier == "HorizontalScrolling" ? 1 : sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let listCell = cell as? SKListCell {
            listCell.willDisplay()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        
        let itemData = sections[indexPath.section].items[safe: indexPath.row]
        
        // Get id based on methods
        var reuseIdentifier = SKListCell.reuseIdentifier
        
        if let reuseIdentifierForIndexPath = reuseIdentifierForIndexPath {
            reuseIdentifier = reuseIdentifierForIndexPath(indexPath)
        }
        
        if let reuseIdForCell = sections[indexPath.section].reuseIdForCell {
            reuseIdentifier = reuseIdForCell(.init(indexPath: indexPath, data: itemData))
        }
       
        if let cellForIndexPath = sections[indexPath.section].cellForIndexPath {
            let cellType = cellForIndexPath(.init(indexPath: indexPath, data: itemData))
            
            // Use backup cell if dummy data
            if let placeholderCell = cellType.placeholderCell, itemData is SKListDummyData {
                reuseIdentifier = placeholderCell.reuseIdentifier
            } else {
                reuseIdentifier = cellType.reuseIdentifier
            }
        }
                
        // Override with horizontal scrolling at end
        if (sections[section].layout?.identifier == "HorizontalScrolling") {
            reuseIdentifier = SKHorizontalScrollListCell.reuseIdentifier
        }
        
        // Get Cell reference
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SKListCell
        
        let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath)
        if let cellWidth = layoutAttributes?.frame.width {
            cell.width = cellWidth
        }
        
        
        // for horizontal scrolling cells make pseudo layout by passing items to cell
        if let cell = cell as? SKHorizontalScrollListCell {
            cell.configure(for: section, sections: sections, cellsToRegister: cellsToRegister)
            cell.onCellTap = onCellTap
        } else {
            cell.configure()
            if let configureCellForReuse = sections[indexPath.section].configureCellForReuse {
                configureCellForReuse(.init(cell: cell, indexPath: indexPath, data: itemData))
            }
        }
        
        // Set selectability state
        if (sections[section].isSelectable == true) {
            cell.didBecomeSelectable(isSelected: selectedIds.contains(itemData?.id ?? ""))
        } else {
            cell.didBecomeDeselectable()
        }
        
        

        return cell
    }
    
    // ---
    // Header
    // ---
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = indexPath.section
        let items = sections[section].items
        let itemsData = items[safe: indexPath.row]
        
        if (items.count == 0) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: SKEmptyListHeader.reuseIdentifier, for: indexPath) as! SKListHeader
            return header
        }
        
        // Get id based on methods
        var reuseIdentifier = ""
        
        if let headerReuseIdentifierForSection = headerReuseIdentifierForSection {
            reuseIdentifier = headerReuseIdentifierForSection(section)
        }
        
        if let reuseIdForHeader = sections[section].reuseIdForHeader {
            reuseIdentifier = reuseIdForHeader(.init(section: section))
        }
        
        if let layoutHeader = sections[section].layout?.header {
            reuseIdentifier = layoutHeader.reuseIdentifier
        }
        
        // Check if header is registered
        if !(headersToRegister ?? []).contains(where: { headerType in
                headerType.reuseIdentifier == reuseIdentifier
        }) {
            reuseIdentifier = SKListHeader.reuseIdentifier
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "Header", withReuseIdentifier: reuseIdentifier, for: indexPath) as! SKListHeader
        
        if sections[section].title?.isEmpty != nil {
            header.defaultTitleLabel.text = sections[section].title
        }
        
        
        if let configureHeaderForReuse = sections[section].configureHeaderForReuse {
            configureHeaderForReuse(.init(header: header, section: section, data: itemsData))
        }
        
        header.configure()
        
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SKListCell
        let cellData = sections[indexPath.section].items[indexPath.row]
        
        if sections[indexPath.section].isSelectable {
            let id = cellData.id
            if selectedIds.contains(id ?? "") {
                onCellDeselected?(.init(cell: cell, indexPath: indexPath, data: cellData))
                selectedIds.removeAll(where: {$0 == id})
                cell.setIsDeselected()
            } else {
                onCellSelected?(.init(cell: cell, indexPath: indexPath, data: cellData))
                selectedIds.append(id ?? "")
                cell.setIsSelected()
            }
        } else {
            if let onTap = sections[indexPath.section].items[indexPath.row].onTap {
                onTap(.init(cell: cell, indexPath: indexPath, data: cellData))
            }
            onCellTap?(.init(cell: cell, indexPath: indexPath, data: cellData))
            delegate?.onCellTap(event: .init(cell: cell, indexPath: indexPath, data: cellData))
        }
    }
}



// Stub for potential delegate approach
protocol SKListDelegate: AnyObject {
    func onCellTap(event:SKCellTapEvent)
}

enum SKListCellHeight: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    
    case value(CGFloat)
    case function((_ width: CGFloat, _ cellWidth: CGFloat?, _ columns: CGFloat, _ spacing: CGFloat,
                    _ padding: NSDirectionalEdgeInsets) -> CGFloat)
    
    // Support for float literals (like 10.5)
    init(floatLiteral value: Double) {
        self = .value(CGFloat(value))
    }
    
    // Support for integer literals (like 10)
    init(integerLiteral value: Int) {
        self = .value(CGFloat(value))
    }
    
    // Initialize directly from CGFloat
    init(_ float: CGFloat) {
        self = .value(float)
    }
    
    // Initialize from function
    init(_ function: @escaping (_ width: CGFloat, _ cellWidth: CGFloat?, _ columns: CGFloat, _ spacing: CGFloat,
                                _ padding: NSDirectionalEdgeInsets) -> CGFloat) {
        self = .function(function)
    }
    
    func evaluate(with width: CGFloat, cellWidth: CGFloat? = nil, columns: CGFloat, spacing: CGFloat, padding: NSDirectionalEdgeInsets) -> CGFloat {
        switch self {
        case .value(let float):
            return float
        case .function(let closure):
            return closure(width, cellWidth, columns, spacing, padding)
        }
    }
}

protocol SKListItemData {
    var id: String? { get }
    var onTap: ((_ event: SKCellTapEvent) -> Void)? { get }
}

extension SKListItemData {
    var onTap: ((_ event: SKCellTapEvent) -> Void)? {
        // Default behavior when onTap is not provided
        return { event in }
    }
}

class WeakCellReference {
    weak var cell: UICollectionViewCell?
    init(cell: UICollectionViewCell?) {
        self.cell = cell
    }
}

// Use for loading placements
struct SKListDummyData: SKListItemData {
    var id: String?
    var isLoading: Bool = true
}

// Use for static placements
struct SKListPlaceholderData: SKListItemData {
    var id: String?
}

struct SKCellEvent {
    var cell: SKListCell? = nil
    var indexPath: IndexPath?
    var data: SKListItemData? = nil
}

struct SKHeaderEvent {
    var header: SKListHeader? = nil
    var section: Int?
    var data: SKListItemData? = nil
}

struct SKCellTapEvent {
    var cell: SKListCell?
    var indexPath: IndexPath?
    var data: SKListItemData?
}

struct SKCellSelectedEvent {
    var cell: SKListCell?
    var indexPath: IndexPath?
    var data: SKListItemData?
}

struct SKCellDeselectedEvent {
    var cell: SKListCell?
    var indexPath: IndexPath?
    var data: SKListItemData?
}

struct SKListScrollEvent {
    var y: CGFloat
    var previousY: CGFloat
}


class SKListLayoutSection: NSCollectionLayoutSection {
    var cellHeight: CGFloat? = nil
    var cellWidth: CGFloat? = nil
    var identifier: String? = nil
    var width: CGFloat? = nil
    var padding: NSDirectionalEdgeInsets? = nil
    var columns: CGFloat? = nil
    var columnSpacing: CGFloat? = nil
    var header: SKListHeader.Type? = nil
}

struct SKListSection {
    
    var id: String?
    var title: String?
    var items: [SKListItemData]
    var layout: SKListLayoutSection?
    
    var reuseIdForCell: ((_ event: SKCellEvent) -> String)?
    var cellForIndexPath: ((_ event: SKCellEvent) -> SKListCell.Type)?
    
    var configureCellForReuse: ((_ event: SKCellEvent) -> Void)?
    
    var reuseIdForHeader: ((_ event: SKHeaderEvent) -> String)?
    var configureHeaderForReuse: ((_ event: SKHeaderEvent) -> Void)?
    
    var onCellTap: ((_ event: SKCellTapEvent) -> Void)?
    
    var isSelectable: Bool = false
    var onCellSelected: ((_ event: SKCellSelectedEvent) -> Void)?
    var onCellDeselected: ((_ event: SKCellDeselectedEvent) -> Void)?

}

