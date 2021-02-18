//
//  test.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/15/21.
//

import Foundation
import FirebaseFirestore

class RunDb {
    private var user: User;
    private var path: Path;
    
    init(user: User) {
        self.user = user;
        self.path = Path.init(user: user);
    }
    
    // CALL EVERY INTERVAL 
    func saveRunSnapShot(runSnapShot: [RunSnapshot], runID: String) {
        let ref = path.userEachRun(runID: runID);
        let list = runSnapShot.map { (runlist) -> [String: Any] in
           return runlist.toJSON()
        };
        ref.setData([
            "runData": FieldValue.arrayUnion(list) // MIGHT NOT WORK
        ], merge: true);
    }

}
