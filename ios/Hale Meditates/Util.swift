import Foundation
import SystemConfiguration
import UIKit

class Util {
    
    enum PRIORITY : Int {
        case SUPER_LOW =  0
        case LOW = 1
        case MEDIUM = 2
        case HIGH = 3
        case SUPER_HIGH = 4
    }
    
    static func getQualityOfServiceByPriority(p: PRIORITY?) -> Int {
        if (p == nil) {
            return Int(QOS_CLASS_DEFAULT.value);
        }
        
        switch (p!) {
        case .SUPER_LOW:
            return Int(QOS_CLASS_BACKGROUND.value);
        case .LOW:
            return Int(QOS_CLASS_UTILITY.value);
        case .MEDIUM:
            return Int(QOS_CLASS_DEFAULT.value);
        case .HIGH:
            return Int(QOS_CLASS_USER_INITIATED.value);
        case .SUPER_HIGH:
            return Int(QOS_CLASS_USER_INTERACTIVE.value);
        default:
            return Int(QOS_CLASS_DEFAULT.value);
        }
    }
    
    static func enqueue (task: () -> Void, priority: PRIORITY?) {
        let qos = getQualityOfServiceByPriority(priority)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            task();
        }
    }
    
    static func buildUserSavedPath(fileName: String) -> String {
        var documentsDirectory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as! String;
        var path = documentsDirectory.stringByAppendingPathComponent(fileName);
        return path;
    }
}