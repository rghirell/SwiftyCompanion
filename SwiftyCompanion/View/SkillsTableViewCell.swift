//
//  SkillsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/13/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

  
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var skillsName: UILabel!
    @IBOutlet weak var skillValue: UILabel!
    @IBOutlet weak var progressBarL: UIView!
    var done: NSLayoutConstraint?
    
    var skills: Skills? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if done != nil {
            done?.isActive = false
        }
        progressBar.layer.cornerRadius = 5.0
        progressBar.layer.borderWidth = 1.0
        progressBarL.layer.borderWidth = 1.0
        progressBarL.layer.cornerRadius = 4.0
        let x = (skills!.level! * 4) / 100
        done = progressBarL.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: CGFloat(x))
        done?.isActive = true
        skillsName.text = skills!.name
        skillValue.text = String(skills!.level!.rounded())
        skillValue.textColor = UIColor(rgb: UIColor.RGB(r: 252,g:255,b:255))
    
    
    }

}
