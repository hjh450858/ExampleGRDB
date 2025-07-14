//
//  MainVM.swift
//  ExampleGRDB
//
//  Created by 황재현 on 7/10/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainVM: NSObject {
    
    
    func fetchMemo() -> Observable<[MemoModel]> {
        return Observable.create { observer in
            do {
                try DBManager.shared.dbQueue.read({ db in
                    observer.onNext(try MemoModel.fetchAll(db))
                })
            } catch let error {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func addMemo(text: String) {
        print("addMemo - text = \(text)")
        let title = text
        let content = "\(Int.random(in: 1...1000))"
        DBManager.shared.addMemo(title: title, content: content)
    }
}
