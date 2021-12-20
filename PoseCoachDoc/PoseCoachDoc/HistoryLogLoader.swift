//
//  HistoryLogLoader.swift
//  PoseCoachDoc
//
//  Created by 吳得人 on 2021/12/20.
//

import Foundation

enum LoadResult {
    case success([HistoryLogItem])
    case error(Error)
}

protocol HistoryLogLoader {
    func load(completion: @escaping(LoadResult) -> Void)
}
