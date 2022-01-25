//
//  PitchCollectionViewCell.swift
//  iGo
//
//  Created by Mavin Sao on 22/12/21.
//

import UIKit

class PitchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    var btnGoTapped: ((UICollectionViewCell)-> Void)?
    var btnCallTapped: ((UICollectionViewCell)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.thumbnail.layer.cornerRadius = 5
    }
    
    func config(pitch: Pitch){
        self.titleLabel.text = pitch.name
        self.location.text = pitch.location
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        btnGoTapped?(self)
    }
    @IBAction func btnCallPressed(_ sender: Any) {
        btnCallTapped?(self)
    }
    
}
