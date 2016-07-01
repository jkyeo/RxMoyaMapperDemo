//
//  RxMoyaResponseMapper.swift
//
//  Created by Kooze on 16/6/29.
//  Copyright © 2016年 purisen. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

enum ORMError : ErrorType {
    case ORMNoRepresentor
    case ORMNotSuccessfulHTTP
    case ORMNoData
    case ORMCouldNotMakeObjectError
    case ORMBizError(resultCode: String?, resultMsg: String?)
}

enum BizStatus: String {
    case BizSuccess = "200"
    case BizError
}

public protocol Mapable {
    init?(jsonData:JSON)
}

let RESULT_CODE = "resultcode"
let RESULT_MSG = "reason"
let RESULT_DATA = "result"

extension Observable {
    
    private func resultFromJSON<T: Mapable>(jsonData:JSON, classType: T.Type) -> T? {
        return T(jsonData: jsonData)
    }
    
    
    func mapResponseToObj<T: Mapable>(type: T.Type) -> Observable<T?> {
        return map { representor in
            // get Moya.Response
            guard let response = representor as? Moya.Response else {
                throw ORMError.ORMNoRepresentor
            }
            
            // check http status
            guard ((200...209) ~= response.statusCode) else {
                throw ORMError.ORMNotSuccessfulHTTP
            }
            
            // unwrap biz json shell
            let json = JSON.init(data: response.data)
            
            // check biz status
            if let code = json[RESULT_CODE].string {
                if code == BizStatus.BizSuccess.rawValue {
                    // bizSuccess -> return biz obj
                    return self.resultFromJSON(json[RESULT_DATA], classType:type)
                } else {
                    // bizError -> throw biz error
                    throw ORMError.ORMBizError(resultCode: json[RESULT_CODE].string, resultMsg: json[RESULT_MSG].string)
                }
            } else {
                throw ORMError.ORMCouldNotMakeObjectError
            }
        }
    }
    
    func mapResponseToObjArray<T: Mapable>(type: T.Type) -> Observable<[T]> {
        return map { response in
            
            // get Moya.Response
            guard let response = response as? Moya.Response else {
                throw ORMError.ORMNoRepresentor
            }
            
            // check http status
            guard ((200...209) ~= response.statusCode) else {
                throw ORMError.ORMNotSuccessfulHTTP
            }
            
            // unwrap biz json shell
            let json = JSON.init(data: response.data)
            
            // check biz status
            if let code = json[RESULT_CODE].string {
                if code == BizStatus.BizSuccess.rawValue {
                    // bizSuccess -> wrap and return biz obj array
                    var objects = [T]()
                    let objectsArrays = json[RESULT_DATA].array
                    if let array = objectsArrays {
                        for object in array {
                            if let obj = self.resultFromJSON(object, classType:type) {
                                objects.append(obj)
                            }
                        }
                        return objects
                    } else {
                        throw ORMError.ORMNoData
                    }
                    
                } else {
                    throw ORMError.ORMBizError(resultCode: json[RESULT_CODE].string, resultMsg: json[RESULT_MSG].string)
                }
            } else {
                throw ORMError.ORMCouldNotMakeObjectError
            }
            
        }
    }
}

