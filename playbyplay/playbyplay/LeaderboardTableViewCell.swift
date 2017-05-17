//
//  LeaderboardTableViewCell.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 5/17/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var runsLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var diamond: UIImageView!
    @IBOutlet weak var inningLabel: UILabel!
    @IBOutlet weak var innSignifier: UILabel!
    @IBOutlet weak var rSignifier: UILabel!
    @IBOutlet weak var hiSignifier: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
