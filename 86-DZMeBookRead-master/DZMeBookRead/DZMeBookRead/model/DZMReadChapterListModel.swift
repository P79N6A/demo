//
//  DZMReadChapterListModel.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/12.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadChapterListModel: NSObject,NSCoding {
    
    /// 小说ID
    var bookID:String!
    
    /// 章节ID
    var id:String!
    
    /// 章节名称
    var name:String!
    
    /// 优先级 (一般章节段落都带有排序的优先级 从 0 开始)
    var priority:NSNumber!
    
    // MARK: -- 操作
    func readChapterModel(isUpdateFont:Bool = false) ->DZMReadChapterModel? {
        
        if DZMReadChapterModel.IsExistReadChapterModel(bookID: bookID, chapterID: id) {
            
            return DZMReadChapterModel.readChapterModel(bookID: bookID, chapterID: id, isUpdateFont: isUpdateFont)
        }
        
        return nil
    }
    
    // MARK: -- NSCoding
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        priority = aDecoder.decodeObject(forKey: "priority") as! NSNumber
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        id = aDecoder.decodeObject(forKey: "id") as! String
        
        name = aDecoder.decodeObject(forKey: "name") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(priority, forKey: "priority")
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(id, forKey: "id")
        
        aCoder.encode(name, forKey: "name")
    }
}
