//
//  db.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation

class DB {
    private var user: User;
    public var runDb : RunDb;
    public var userDb : UserDb;
    public var friendDb : FriendDb;
    
    init() {
        self.user = LocalStorage().getUser();
        self.runDb = RunDb.init(user: user);
        self.userDb = UserDb.init(user: user);
        self.friendDb = FriendDb.init(user: user);
    }
    
    
    
    
    private func checkUser() {
        if (!LocalStorage().userExist()) {
            // log out
        }
    }
    
}
