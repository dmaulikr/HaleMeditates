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
            return Int(QOS_CLASS_DEFAULT.rawValue);
        }
        
        switch (p!) {
        case .SUPER_LOW:
            return Int(QOS_CLASS_BACKGROUND.rawValue);
        case .LOW:
            return Int(QOS_CLASS_UTILITY.rawValue);
        case .MEDIUM:
            return Int(QOS_CLASS_DEFAULT.rawValue);
        case .HIGH:
            return Int(QOS_CLASS_USER_INITIATED.rawValue);
        case .SUPER_HIGH:
            return Int(QOS_CLASS_USER_INTERACTIVE.rawValue);
        }
    }
    
    static func enqueue (task: () -> Void, priority: PRIORITY?) {
        let qos = getQualityOfServiceByPriority(priority)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            task();
        }
    }
    
    static func buildUserSavedPath(fileName: String) -> String {
        let documentsDirectory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
        let documentsURL = NSURL(string: documentsDirectory);
        return documentsURL?.URLByAppendingPathComponent(fileName).absoluteString ?? "";
    }
    
    static func openResourceFile(name: String, ext: String) -> String? {
        if let path = NSBundle.mainBundle().pathForResource(name, ofType: ext) {
            do {
                return try String(contentsOfFile: path);
            } catch _ {
                return nil
            };
        } else {
            return nil;
        }
    }
}