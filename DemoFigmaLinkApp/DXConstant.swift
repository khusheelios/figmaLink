//
//  DXConstant.swift
//  DemoColorCodeApp
//
//  Created by CG App Mac on 07/04/22.
//

import UIKit


// MARK: - Provides details of the current app.
public protocol AppInfo { }

var sharedUserDefaults: UserDefaults { return (UserDefaults.standard) }

var shared: DXShared { return DXShared.shared }

var AESEncryptionKey: String { return "DemoApplication" }

private let configuration = "AppConfiguration"


public class DXShared: NSObject {
    static let shared = DXShared()
  
    var configurationModel: AppConfigurationModel?
    
    private override init () {
        super.init()
        self.createModels()
    }
    
    fileprivate func createModels() {
        do {
            if let dictConfiguration = self.retrieveConfigurationModalFromUserDefaults(key: configuration) {
                self.configurationModel = try JSONDecoder().decode(AppConfigurationModel.self, from: dictConfiguration)
            }
        } catch {print(error.localizedDescription)}
    }
    
    public func retrieveConfigurationModalFromUserDefaults(key: String) -> Data? {
        if let configurationData = sharedUserDefaults.value(forKey: key) as? Data {
            let aesValue = AES()?.decrypt(data: configurationData)
            let data = String(any: aesValue).toData
            return data
        } else { return nil }
    }
    

}

extension DXShared: AppInfo {
    
    var primaryColor: UIColor {
        let color = self.configurationModel?.primaryColor ?? HashColor.defaultColor.rawValue
        return UIColor.convertHexStringToColor(hexString: color)
    }
    var secondaryColor: UIColor {
        let color = self.configurationModel?.secondaryColor ?? HashColor.secondaryDefault.rawValue
        return UIColor.convertHexStringToColor(hexString: color)
    }

}
