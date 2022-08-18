//
//  DetailedNewsTableViewCell.swift
//  NewsApp
//
//  Created by Kavya on 18/08/22.
//

import UIKit
import Kingfisher

class DetailedNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var headlineSource: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setHeadlines(for article: Article) {
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineImage.translatesAutoresizingMaskIntoConstraints = false
        headlineImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        headlineImage.widthAnchor.constraint(equalTo: headlineImage.heightAnchor, multiplier: 12/9).isActive = true

        if let safeTitle = article.title {
            let str = safeTitle.components(separatedBy: " - ")[0] // Remove everything after " - "
            headlineLabel.text = str
        }
        
        if let safeSource = article.source.name {
            headlineSource.text = safeSource
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 40)
        headlineImage.kf.indicatorType = .activity
        print("imageurl", article.urlToImage)
        if let safeImageURL = article.urlToImage {
            headlineImage.kf.setImage(with: URL(string: safeImageURL), options: [.processor(processor), .transition(.fade(0.2))]) { result in
                switch result {
                case .success(let value):
                    self.headlineLabel.trailingAnchor.constraint(equalTo: self.headlineImage.leadingAnchor, constant: -5).isActive = true
                    self.headlineImage.image = value.image
                case .failure(let error):
                    print(error)
                    self.headlineLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
                }
            }
        }
    }
    

}
