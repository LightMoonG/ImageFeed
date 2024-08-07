//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Глеб Хамин on 25.06.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Cell Identifier
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Properties
    
    weak var delegate: ImagesListCellDelegate?
    
    lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .ypGray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        view.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let colorTop = UIColor { _ in UIColor(named: "YP Black") ?? UIColor.black }.withAlphaComponent(0).cgColor
        let colotBottom = UIColor { _ in UIColor(named: "YP Black") ?? UIColor.black }.withAlphaComponent(0.2).cgColor
        gradientLayer.colors = [colorTop, colotBottom]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 1]
        
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .ypWhite
        lable.font = .systemFont(ofSize: 13)
        return lable
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        button.accessibilityIdentifier = "LikeButton"
        return button
    }()
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer else { return }
        gradientLayer.frame = gradientView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "likeButtonOn") : UIImage(named: "likeButtonOff")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        
        contentView.addSubview(cellImage)
        contentView.addSubview(gradientView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            gradientView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
            dateLabel.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}


