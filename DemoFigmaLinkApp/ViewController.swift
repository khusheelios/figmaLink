//
//  ViewController.swift
//  DemoFigmaLinkApp
//
//  Created by CG App Mac on 21/04/22.
//

import UIKit
import SwiftyJSON
class ViewController: UIViewController {

    @IBOutlet weak var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        
        // Do any additional setup after loading the view.
    }
    
    func getUserData()
    {
                DataService.shared.getUsers{data in
                    print("Count is",data.count)
                    
                  
                           let json = try! JSON(data: data)
                            print("JsonData :",json.count)
                    
                          
                                let textColor = json["global"]["subheader-textcolor"]["value"]
                                let text_color2 = json["global"]["text-color2"]["value"]
                                let text_border = json["global"]["text-border"]["value"]
                                let background_color = json["global"]["background-color"]["value"]
                                let background_color2 = json["global"]["background-color2"]["value"]
                               
                                print("textColor",textColor,text_color2,text_border,background_color,background_color2)
                              
                    subView.backgroundColor = UIColor(hexString: background_color.rawValue as! String)
                    
        }
    }


}

public struct AppConfigurationModel: Codable {

    let primaryColor: String?
    let secondaryColor: String?
   
    enum CodingKeys: String, CodingKey {
        case primaryColor, secondaryColor
    }
}

public enum HashColor: String {
    case defaultColor = "#0073db"
    case secondaryDefault = "#2a2a2a"
}

public extension String {
    
    init(any anyValue: Any?, defaultValue: String = "") {
        
        self = defaultValue
        
        if let str = anyValue as? String, str != "null" {
            self = String(format: "%@", str).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else if let num = anyValue as? NSNumber {
            
            self = String(format: "%@", num).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var toData: Data? {
        return self.data(using: .utf8) ?? nil
    }
}

public extension UIColor {

     static var primaryColor: UIColor {

        return shared.primaryColor
    }
    static var secondaryColor: UIColor {

        return shared.secondaryColor
    }
    
    static func convertHexStringToColor(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {

       var hexColorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

       if hexColorString.hasPrefix("#") {
           hexColorString.removeFirst()
       }

       if hexColorString.count != 6 {
           NSException.raise(NSExceptionName(rawValue: "convertHexStringToColor Exception"),
                             format: "Error: Invalid hex color string. Please ensure HEX COLOR",
                             arguments: getVaList(["nil"]))
       }

       var hexColorRGBValue: UInt32 = 0
       Scanner(string: hexColorString).scanHexInt32(&hexColorRGBValue)
       return self.changeHexColorCodeToRGB(hex: hexColorRGBValue, alpha: alpha ?? 1.0)
   }
    
    // MARK: Private helper methods
    private
    static func changeHexColorCodeToRGB(hex: UInt32, alpha: CGFloat) -> UIColor {

        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0,
                       green: CGFloat((hex & 0xFF00) >> 8)/255.0,
                       blue: CGFloat((hex & 0xFF))/255.0,
                       alpha: alpha)
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
