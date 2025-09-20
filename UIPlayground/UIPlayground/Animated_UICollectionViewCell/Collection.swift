import UIKit
import SwiftUI

class HostingViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!

    // Sample data to display
    private let data = [
        Item(title: "First Item", subtitle: "This is a subtitle for the first item."),
        Item(title: "Second Item", subtitle: "Another SwiftUI-powered cell."),
        Item(title: "Third Item", subtitle: "Look at that hosting configuration!"),
        Item(title: "Fourth Item", subtitle: "It's a mix of UIKit and SwiftUI."),
        Item(title: "Fifth Item", subtitle: "The best of both worlds.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
    }

    private func setupCollectionView() {
        let layoutConfiguration = {
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            return config
        }()

        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.contentConfiguration = UIHostingConfiguration {
                SwiftUICellView(
                    title: item.title,
                    subtitle: item.subtitle,
                    isExpanded: item.isExpanded,
                    onTap: {
                        self.animateAccordianTap(for: item)
                    }
                )
            }
            cell.selectedBackgroundView = .none
        }

        dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func animateAccordianTap(for item: Item) {
        item.isExpanded.toggle()
        var snapshot = self.dataSource.snapshot()
        snapshot.reloadItems([item])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

struct HostingViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HostingViewController {
        HostingViewController()
    }

    func updateUIViewController(_ uiViewController: HostingViewController, context: Context) {}
}

#Preview {
    HostingViewControllerWrapper()
}
