//
//  ApiService.swift
//
//  Created by Kooze on 16/6/27.
//  Copyright © 2016年 purisen. All rights reserved.
//

import Foundation
import Moya

let headerFields: Dictionary<String, String> = [
    "platform": "iOS",
    "sys_ver": String(UIDevice.version())
]

let appendedParams: Dictionary<String, AnyObject> = [
    "uid": "123456"
]

let endpointClosure = { (target: ApiService) -> Endpoint<ApiService> in
    let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
    return Endpoint(URL: url, sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        .endpointByAddingParameters(appendedParams)
        .endpointByAddingHTTPHeaderFields(headerFields)
    
}

let apiProvider = RxMoyaProvider<ApiService>(endpointClosure: endpointClosure)

enum ApiService {
    case GetRank(area: String?)
}

extension ApiService: TargetType {
    var baseURL: NSURL {return NSURL(string: "http://v.juhe.cn")!}
    var path: String {
        switch self {
        case .GetRank(_):
            return "/boxoffice/rank"
        }
    }
    
    var method: Moya.Method {
        return .GET
    }
    
    var parameters: [String: AnyObject]? {
        
        switch self {
        case .GetRank(let area):
            return [
                "area": nil == area ? "" : area!,
                "key": "e8ec41002b1441dc9126d7bbf259b747"
            ]
        }
    }
    
    var sampleData: NSData {
        return "".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}