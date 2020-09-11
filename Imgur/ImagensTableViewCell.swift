//
//  ImagensTableViewCell.swift
//  Imgur
//
//  Created by Marcio Izar Bastos de Oliveira on 04/09/20.
//  Copyright © 2020 Marcio Izar Bastos de Oliveira. All rights reserved.
//

import UIKit

class ImagensTableViewCell: UITableViewCell {

    @IBOutlet weak var blocoAbaixoView: UIView!
    @IBOutlet weak var blocoAbaixoView2: UIView!
    @IBOutlet weak var imagemEComentarios1View: UIView!
    @IBOutlet weak var imagemEComentarios2View: UIView!
    @IBOutlet weak var cellContentView: UIView!
    
    
    @IBOutlet weak var espacoEntreView: UIView!
    
    @IBOutlet weak var viewEspacoEntreTopETopMarginConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var viewEspacoEntreLeadingEViewImagemEComentarios1Constraints: NSLayoutConstraint!
    @IBOutlet weak var viewImagemEComentarios2LeadingEViewEspacoeEntreTrailingConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var bottomMargimEViewEspacoEntreConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var viewEspacoEntreCenterXConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewEspacoEntreWidthConstraints: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        print("ola")
        
        blocoAbaixoView.backgroundColor = UIColor(red: 0x47/256, green: 0x4A/256, blue: 0x51/256, alpha: 1)
        blocoAbaixoView.layer.cornerRadius = 5
        blocoAbaixoView.layer.borderWidth = 0
        
        blocoAbaixoView2.backgroundColor = UIColor(red: 0x47/256, green: 0x4A/256, blue: 0x51/256, alpha: 1)
        blocoAbaixoView2.layer.cornerRadius = 5
        blocoAbaixoView2.layer.borderWidth = 0
        
//        viewImagemEComentarios1WidthConstraints.isActive = false
//        viewImagemEComentarios2WidthConstraints.isActive = false
        
        
        
//                espacoEntreView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //        cell?.viewEspacoEntreTopETopMarginConstraints.isActive = false
        
//                viewEspacoEntreLeadingEViewImagemEComentarios1Constraints.isActive = false
//                viewImagemEComentarios2LeadingEViewEspacoeEntreTrailingConstraints.isActive = false
//        
//        //        cell?.bottomMargimEViewEspacoEntreConstraints.isActive = false
//        
//                viewEspacoEntreCenterXConstraints.isActive = false
//                viewEspacoEntreWidthConstraints.isActive = false
                
                
        

        
    }
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
