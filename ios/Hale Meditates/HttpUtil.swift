//
//  HTTPUtil.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 9/4/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import Foundation

import Foundation

class HttpUtil {
    
    enum Method: String {
        case OPTIONS = "OPTIONS"
        case GET = "GET"
        case HEAD = "HEAD"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
        case TRACE = "TRACE"
        case CONNECT = "CONNECT"
    }
    
    static func PUT(urlString: String, body: String? = nil, headers: Dictionary<String, String>?, isAsync: Bool, callback: ((data: NSData?) -> Void)?) -> NSData? {
        return request(.PUT, urlString: urlString, body: body, headers: headers, isAsync: isAsync, callback: callback);
    }
    
    static func POST(urlString: String, body: String? = nil, headers: Dictionary<String, String>?, isAsync: Bool, callback: ((data: NSData?) -> Void)?) -> NSData? {
        return request(.POST, urlString: urlString, body: body, headers: headers, isAsync: isAsync, callback: callback)
    }
    
    static func GET(urlString: String, body: String? = nil, headers: Dictionary<String, String>?, isAsync: Bool, callback: ((data: NSData?) -> Void)?) -> NSData? {
        return request(.GET, urlString: urlString, body: body, headers: headers, isAsync: isAsync, callback: callback);
    }
    
    static func request(method: Method, urlString: String, body: String? = nil, headers: Dictionary<String, String>?, isAsync: Bool, callback: ((data: NSData?) -> Void)?) -> NSData? {
        if (isAsync) {
            requestAsync(method, urlString: urlString, body: body, headers: headers, callback: callback);
            return nil;
        } else {
            return requestSync(method, urlString: urlString, body: body, headers: headers);
        }
    }
    
    static func requestAsync(method: Method, urlString: String, body: String? = nil, headers: Dictionary<String, String>?, callback: ((data: NSData?) -> Void)?) {
        let qos = Int(QOS_CLASS_USER_INITIATED.value);
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            var data = HttpUtil.requestSync(method, urlString: urlString, body: body, headers: headers);
            if callback != nil {
                callback!(data: data);
            }
        }
    }
    
    static func requestSync(method: Method, urlString: String, body: String? = nil, headers: Dictionary<String, String>?) -> NSData? {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = method.rawValue;
        
        if headers != nil {
            for (header, value) in headers! {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        
        var response = AutoreleasingUnsafeMutablePointer<NSURLResponse?>()
        var error = NSErrorPointer()
        return NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error);
    }
    
    class Request {
        var headers = Dictionary<String, String>();
        var url: String!
        var body: String?
        var method: Method!
        var isAsync: Bool!;
        var callback: ((data: NSData?) -> Void)?
        
        func sendRequest() ->  NSData? {
            return HttpUtil.request(method, urlString: url, body: body, headers: headers, isAsync: isAsync, callback: callback)
        }
        
    }
    
    class RequestBuilder {
        
        private var request = Request();
        
        func PUT(url: String, body: String? = nil) -> RequestBuilder {
            request.method = .PUT;
            request.body = body;
            return self;
        }
        
        func POST(url: String, body: String? = nil) -> RequestBuilder {
            request.method = .POST;
            request.body = body;
            return self;
        }
        
        func GET(url: String, body: String? = nil) -> RequestBuilder {
            request.method = .GET;
            request.body = body;
            return self;
        }
        
        func addHeaderField(header: String, value: String) -> RequestBuilder {
            request.headers[header] = value;
            return self;
        }
        
        func Sync() -> Request {
            request.isAsync = false;
            return request;
        }
        
        func Callback(callback: ((data: NSData?) -> Void)?) {
            request.callback = callback;
        }
        
        func Build() -> Request {
            return request;
        }
        
        
        func Async() -> Request {
            request.isAsync = true;
            return request;
        }
    }
    
    
}