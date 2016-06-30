//
//  BoxofficeModel.swift
//  RxMoyaMapperDemo
//
//  Created by Kooze on 16/6/30.
//  Copyright © 2016年 jkyeo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BoxofficeModel: Mapable {
    let rid: String?
    let name: String?
    let wk: String?
    let wboxoffice: String?
    let tboxoffice: String?
    
    init?(jsonData: JSON) {
        self.rid = jsonData["rid"].string
        self.name = jsonData["name"].string
        self.wk = jsonData["wk"].string
        self.wboxoffice = jsonData["wboxoffice"].string
        self.tboxoffice = jsonData["tboxoffice"].string
    }
}