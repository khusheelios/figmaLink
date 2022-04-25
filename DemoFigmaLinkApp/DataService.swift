//
//  DataService.swift
//  DemoFigmaLinkApp
//
//  Created by CG App Mac on 25/04/22.
//

import Foundation
class DataService
{
    static let shared = DataService()
    
    func getUsers(completion:(Data) -> Void)
    {
        guard let path = Bundle.main.path(forResource: "tokens", ofType: "json") else{return}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        print("Url data",data)
        completion(data)
        
    }
}
