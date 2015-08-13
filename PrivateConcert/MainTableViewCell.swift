//
//  MainTableViewCellController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/28/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var playButton: MediaButton!
    @IBOutlet weak var flagButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
