//
//  NewsTableViewCell.swift
//  newsApplicationIso
//
//  Created by AL20 on 19/06/23.
//

import UIKit

class NewsTableViewCellViewModle{
    let title : String
    let subtitle : String
    let imageURL : URL?
    var imageData : Data? = nil
    
    init(title: String, subtitle: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLable: UILabel = {
         let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22,weight: .semibold)
        return label
    }()
    
    private let subTitleLable: UILabel = {
         let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17 ,weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLable)
        contentView.addSubview(subTitleLable)
        contentView.addSubview(newsImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLable.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        subTitleLable.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 140, y: 5, width: 160, height: contentView.frame.size.height - 10)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLable.text = nil
        subTitleLable.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModle: NewsTableViewCellViewModle){
        newsTitleLable.text = viewModle.title
        subTitleLable.text = viewModle.subtitle
         
        //image
        if let data = viewModle.imageData {
            newsImageView.image = UIImage(data: data)
        }else if let url = viewModle.imageURL{
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _,error in
                guard let data = data, error == nil else{
                    return
                }
                viewModle.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
}
