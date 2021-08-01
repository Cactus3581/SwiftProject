//
//  StructTotalModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2021/7/14.
//  Copyright © 2021 cactus. All rights reserved.
//

import Foundation

struct StructTotalModel {
    var total = "total+0"
    var list = [StructTeamModel]()
    var list1 = [Int]()

    init() {
        var chat1 = StructChatModel()
        chat1.chat = "chat-1"
        var chat2 = StructChatModel()
        chat2.chat = "chat-2"
        
        var team1 = StructTeamModel()
        team1.team = "team-1"
        team1.list = [chat1]
        
        var team2 = StructTeamModel()
        team2.team = "team-2"
        team2.list = [chat2]
        self.list = [team1, team2]
    }
    
    mutating func updateTotal(total: String) {
        self.total = total
    }
    
    mutating func updateChat(chat: StructChatModel) {
        // 直接修改 也会报错self.list.first?.list[0] = chat
        var firstTeam = self.list.first
        var chatModels = firstTeam?.list
        chatModels?[0] = chat
        firstTeam?.list = chatModels!
        self.list[0] = firstTeam!
    }
}

struct StructTeamModel {
    var team = "team+0"
    var list = [StructChatModel]()
}

struct StructChatModel {
    var chat: String = "team+0"
    mutating func update(chat: String) {
        self.chat = chat
    }
}
