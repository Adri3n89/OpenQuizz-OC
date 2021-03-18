//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Adrien PEREA on 17/03/2021.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon:UIImageView!
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style:Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    func setStyle(_ style: Style){
        switch style {
        case .correct :
            backgroundColor = UIColor(red: 200/255.0, green: 236/255.0, blue: 160/255.0, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Correct")
            icon.isHidden = false
        case .incorrect :
            backgroundColor = #colorLiteral(red: 0.9448263049, green: 0.5235669613, blue: 0.5747494698, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
        case .standard :
            backgroundColor = #colorLiteral(red: 0.7456983924, green: 0.7650914788, blue: 0.7821338773, alpha: 1)
            icon.isHidden = true
        }
    }
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
}
