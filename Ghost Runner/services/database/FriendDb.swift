//
//  Friend.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/1/21.
//

import Foundation
import FirebaseFirestore

class FriendDb {
    private var user: User;
    private var path: Path;
    
    init(user: User) {
        self.user = user;
        self.path = Path.init(user: user);
    }
    
    
    func findFriendUsingCode(code: String, completion: @escaping((Friend) -> ()))  {
        let ref = path.allUsers().whereField("code", isEqualTo: code).limit(to: 1)
        let async = DispatchGroup()
        async.enter()
        
        ref.getDocuments { (QuerySnapshot, Error ) in
            let snapShots = QuerySnapshot?.documents;
            let snap = snapShots?[0]
            let data = snap?.data() as! [String : Any];
            let friend = Friend.init(data: data);
            async.leave()
            async.notify(queue: .main) {
                  completion(friend)
                }
        }
    }
    
    func addFriend(friend: Friend) {
        let ref = path.eachFriend(friendUID: friend.uid)
        ref.setData(friend.toJSON(), merge: true);
    }
    
    func getAllFriends(completion: @escaping(([Friend]) -> ())) {
        let ref = path.allFriends()
        var friendList = [Friend]();
        let async = DispatchGroup()
      
        ref.getDocuments() { (querySnapshot, err) in
            async.enter()
            if let err = err {
                print("Error getting documents: \(err)")
                async.leave()
            } else {
                for document in querySnapshot!.documents {
                  
                    let friendData = document.data() as! [String : Any];
                    let friend = Friend(data: friendData);
                    friendList.append(friend)
                }
                async.leave()
                async.notify(queue: .main) {
                      completion(friendList)
                    }
            }
        }
      
    }
    
    func getFriendBestRun(friend: Friend, completion: @escaping((Run) -> ())) {
        let ref = path.friendAllRuns(friendUID: friend.uid).order(by: "avgSpeed", descending: true).limit(to: 1);
        let async = DispatchGroup()
        async.enter()
        
        ref.getDocuments { (QuerySnapshot, Error ) in
            let snapShots = QuerySnapshot?.documents;
            let snap = snapShots?[0]
            let runData: [Any] = (snap?.data()["runData"]) as! [Any];
            let runSnapShot = runData.map { (run) -> RunSnapshot in
                return RunSnapshot(doc: run as! [String : Any]);
            }
            let bestRun = Run(runSnapshotList: runSnapShot, runID: "rand id")
            async.leave()
            async.notify(queue: .main) {
                  completion(bestRun)
                }
        }
      
    }
    

}
