import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    // References
    var list: SKList?
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .primaryBackground
        
        let list = SKList(
            registerCells: [
                SKRowListCell.self,
                SKGridListCell.self,
            ],
            sections: [
                .init(
                    id: "1",
                    title: "Section 1",
                    items: SKList.createDummyData(for: 3),
                    layout: SKList.createGridSection(
                        width: self.view.frame.width,
                        columns: 1,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKRowListCell.self
                    }
                ),
                .init(
                    id: "2",
                    title: "Section 2",
                    items: SKList.createDummyData(for: 5),
                    layout: SKList.createHorizontalScrollingSection(
                        width: self.view.frame.width,
                        cellHeight: SKGridListCell.cellHeight,
                        visibleCells: 3,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKGridListCell.self
                    }
                ),
                .init(
                    id: "3",
                    title: "Section 3",
                    items: SKList.createDummyData(for: 7),
                    layout: SKList.createGridSection(
                        width: self.view.frame.width,
                        columns: 2,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKRowListCell.self
                    }
                ),
                .init(
                    id: "4",
                    title: "Section 4",
                    items: SKList.createDummyData(for: 5),
                    layout: SKList.createHorizontalScrollingSection(
                        width: self.view.frame.width,
                        cellHeight: SKGridListCell.cellHeight,
                        visibleCells: 2,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKGridListCell.self
                    }
                ),
                .init(
                    id: "5",
                    title: "Section 5",
                    items: SKList.createDummyData(for: 100),
                    layout: SKList.createGridSection(
                        width: self.view.frame.width,
                        columns: 1,
                        header: SKListHeader.self
                    ),
                    cellForIndexPath: { event in
                        return SKRowListCell.self
                    }
                ),
            ]
        )
        
        list.collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(list)
        self.list = list
        
        // Add constraints
        NSLayoutConstraint.activate([
            list.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            list.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            list.topAnchor.constraint(equalTo: view.topAnchor),
            list.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
}


// Example using swift ui in uikit context
extension ViewController {
    struct ContentView: View {
        var title: String?
        var onLogout: (() -> Void)?
        var onListen: (() -> Void)?
        
        @State var count = 0
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Welcome")
                    .font(.title)
                    .foregroundStyle(.white)
                Button("Logout", action: {
                    onLogout?()
                })
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(.greatestFiniteMagnitude)
                
                Button("On Listen", action: {
                    onListen?()
                })
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(.greatestFiniteMagnitude)
                
                Button("Count \(count)", action: {
                    count += 1
                })
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(.greatestFiniteMagnitude)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
        }
    }
    
}

#Preview {
    ViewController.ContentView()
}

