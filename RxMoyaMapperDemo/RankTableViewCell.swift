//
//  RankTableViewCell.swift
//  RxMoyaMapperDemo
//
//  Created by Kooze on 16/6/30.
//  Copyright © 2016年 jkyeo. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
