//
//  MemoModel.swift
//  ExampleGRDB
//
//  Created by 황재현 on 7/10/25.
//

import Foundation
import GRDB

struct MemoModel: Codable, FetchableRecord, PersistableRecord, Identifiable {
    static let databaseTableName = "exampleMemo"
    
    
    var id: Int64?
    
    var title: String
    var content: String
    var date: Date
    
    init(id: Int64? = nil, title: String, content: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}
