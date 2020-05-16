//
//  URLConstant.swift
//  AppVersion
//
//  Created by Lohen Yumnam on 16/05/20.
//  Copyright © 2020 co.ameba. All rights reserved.
//

import Foundation


var components: URLComponents {
    get {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "itunes.apple.com"
        return components
    }
}


func getLookupURL(with queryItems: [URLQueryItem]? ) -> URL? {
    var c = components
    c.path = "/lookup"
    c.queryItems = queryItems
    return c.url
}
