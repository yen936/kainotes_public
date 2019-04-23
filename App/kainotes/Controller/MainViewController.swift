//
//  ViewController.swift
//  kainotes
//
//  Created by Benji Magnelli on 3/27/19.
//  Copyright © 2019 Biblical Education LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public let kainotesGray =  UIColor.init(red: 223/255, green: 230/255, blue: 233/255, alpha: 0.5)
public let kainotesBlack = UIColor.init(red: 45/255, green: 52/255, blue: 54/255, alpha: 0.5)


class MainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstrants()
        getVerse()

    }

    @IBOutlet weak var backroundOutles: UIImageView!
    @IBOutlet weak var verseOutlet: UILabel!
    @IBOutlet weak var referenceOutlet: UILabel!
    @IBOutlet weak var referenceView: UIView!
    
    
    
    
    func getVerse()  {
        let url = //Add your networking URI
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let verseJSON = JSON(response.result.value!)
                
                self.updateVerseUI(verseJSON: verseJSON)
                self.updateBackroud(verseJSON: verseJSON)

            
            }
                
            else if response.result.isFailure {
                print(response.error as Any)
                self.verseOutlet.text = "Service Currently Unavailabe, 😕"
            }
        }
    }
    
    
    func updateBackroud(verseJSON: JSON) {
        let images = ["rainbow_light", "bird_dark", "field_1_light", "flowers_1_light", "flowers:w_mount_light", "mount_dark", "lake_dark", "rocks_2_light", "flowers_1_light", "rocks_dark", "dune_2", "dune_1", "waves_3", "mount_4", "tiger", "man_water", "mount_3", "ice_mount", "waves_1", "tree_2", "benj1", "benj2", "benj3", "benj4", "benj5", "benj6", "benj7", "benj8", "benj9", "benj10", "benj11", "benj12", "benj13", "benj14", "benj15", "benj16", "benj17", "benj18", "benj19", "benj20" ]
        let backgroundNumber = verseJSON["background_number"].intValue
        let backround = images[backgroundNumber]
        backroundOutles.image = UIImage(named: backround)
        
//        let words = backround!.split(separator: "_")
//        let last = String(words.last!)
//
//        if  last == Optional("light") {
//            verseOutlet.textColor = UIColor.black
//            versionOutlet.textColor = UIColor.black
//            referenceOutlet.textColor = UIColor.black
//        }
//        else if last == Optional("dark") {
//            verseOutlet.textColor = UIColor.white
//            versionOutlet.textColor = UIColor.white
//            referenceOutlet.textColor = UIColor.white
//
//        }
//        else {
//            print("error at the updating of the text color in updateBackround")
//        }
        
    
        
    }
    
    func updateVerseUI(verseJSON : JSON) {
        verseOutlet.clipBounds()
        verseOutlet.backgroundColor = kainotesBlack
        
        referenceView.backgroundColor = kainotesBlack
        referenceView.layer.cornerRadius = 30
        referenceView.layer.masksToBounds = true
        
        let ref = verseJSON["reference"].string!
        let version = verseJSON["version"].string!
        
        self.verseOutlet.text = verseJSON["verse"].string
        self.referenceOutlet.text = "\(ref) \(version)"
        
        
    }
    
    func setConstrants() {
        backroundOutles.translatesAutoresizingMaskIntoConstraints = false
        backroundOutles.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backroundOutles.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backroundOutles.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backroundOutles.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
}

//MARK: End of Class
//************************************************************************************************************************

extension UILabel {
    func clipBounds() {
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
        self.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0
        
        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth
        
        return contentSize
    }
}



