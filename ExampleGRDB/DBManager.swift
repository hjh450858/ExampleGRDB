//
//  DBManager.swift
//  ExampleGRDB
//
//  Created by 황재현 on 7/10/25.
//

import Foundation
import GRDB

class DBManager {
    static let shared = DBManager()
    var dbQueue: DatabaseQueue!
    
    
    private init() {
        let path = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("exampleMemo.sqlite")
            .path
        
        dbQueue = try? DatabaseQueue(path: path)
        
        try? dbQueue.write({ db in
            try db.create(table: "exampleMemo", ifNotExists: true) { text in
                text.autoIncrementedPrimaryKey("id")
                text.column("title", .text).notNull()
                text.column("content", .text).notNull()
                text.column("date", .date).notNull()
            }
        })
    }
    // 메모작성
    func addMemo(title: String, content: String) {
        let newMemo = MemoModel(id: nil, title: title, content: content)
        do {
            // db큐에 접근
            try? dbQueue.write { db in
                // 새로운 메모를 db에 넣기
                try newMemo.insert(db)
            }
        } catch let error {
            print("addMemo - error = \(error)")
        }
    }
    
    func deleteMemo(memo: MemoModel) {
        try? dbQueue.write({ db in
            try memo.delete(db)
        })
    }
}
