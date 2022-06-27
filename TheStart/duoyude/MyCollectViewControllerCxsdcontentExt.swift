import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

extension MyCollectViewController {
    func viewDidLoadMzBrsCxsdcontent(_ CXSDContent: String) {
        print(CXSDContent)
    }
    func onResponseIYVpBCxsdcontent(_ CXSDContent: String, requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        print(CXSDContent)
    }
    func onFailurelNpIXCxsdcontent(_ CXSDContent: String, responseCode: String, description: String, requestPath: String) {
        print(CXSDContent)
    }
}
