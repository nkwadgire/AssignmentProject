/**
*  * *****************************************************************************
*  * Filename: CustomCell.swift
*  * Author  : Nagraj Wadgire
*  * Creation Date: 17/12/20
*  * *
*  * *****************************************************************************
*  * Description:
*  * Custom cell to define the UI design of the tableView row
*  *                                                                             *
*  * *****************************************************************************
*/

import UIKit

class CustomCell: UITableViewCell {
    weak var imgView: UIImageView!
    weak var titleLabel: UILabel!
    weak var subTitleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        let imgView = UIImageView(frame: .zero)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imgView)
        self.imgView = imgView
        self.imgView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subTitleLabel = UILabel(frame: .zero)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(subTitleLabel)
        self.subTitleLabel = subTitleLabel
        
        self.addconstraintsForImageView()
        self.addconstraintsForTitle()
        self.addconstraintsForSubTitle()

        self.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        self.subTitleLabel.numberOfLines = 0
        self.subTitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
        self.titleLabel.text = ""
        self.subTitleLabel.text = ""
    }
    
    // MARK: - Private Functions
    
    private func addconstraintsForImageView() {
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.imgView.topAnchor, constant: -10),
            self.contentView.leftAnchor.constraint(equalTo: self.imgView.leftAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 10),
            self.imgView.widthAnchor.constraint(equalToConstant: 100),
            self.imgView.heightAnchor.constraint(equalToConstant: 100),
            self.contentView.centerYAnchor.constraint(equalTo: self.imgView.centerYAnchor)
        ])
    }
    
    private func addconstraintsForTitle() {
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -10),
            self.titleLabel.leftAnchor.constraint(equalTo: self.imgView.rightAnchor, constant: 20),
            self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func addconstraintsForSubTitle() {
        NSLayoutConstraint.activate([
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
            self.subTitleLabel.leftAnchor.constraint(equalTo: self.imgView.rightAnchor, constant: 20),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.subTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            self.subTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 534)
        ])
    }
}
