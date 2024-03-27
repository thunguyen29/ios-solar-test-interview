//
//  InstructiontCell.swift
//  SolarTestInterview
//

import UIKit

class InstructiontCell: UITableViewCell {
    
    
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var chevronImgView: UIImageView!
    
    func setupData(title: String, content: String, isCollapse: Bool) {
        titleLable.text = title
        contentLabel.text = isCollapse ? "" : content
        chevronImgView.image = isCollapse ? #imageLiteral(resourceName: "chevron-down.png") : #imageLiteral(resourceName: "chevron-up.png")
        setupShadow()
    }
    
    private func setupShadow() {
        bgView.layer.cornerRadius = 8
        
        bgView.layer.shadowColor = UIColor(hex: "#2D4883")?.withAlphaComponent(0.16).cgColor
        bgView.layer.shadowOpacity = 0.1
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 8
    }
}
