//
//  TableViewCell.swift
//  FloatingAudioPlayer_Example
//
//  Created by Zhangali Pernebayev on 11/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(audio: AudioModel) {
        nameLabel.text = audio.name
        authorLabel.text = audio.author
    }
}
