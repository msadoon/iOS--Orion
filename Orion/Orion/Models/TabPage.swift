import UIKit

struct TabPage: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
    let image: UIImage?
}
