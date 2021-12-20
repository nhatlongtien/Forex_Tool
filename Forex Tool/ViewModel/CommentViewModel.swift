//
//  CommentViewModel.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 12/12/2021.
//

import Foundation
import SwiftyJSON
import Firebase
import FirebaseDatabase
class CommentViewModel{
    func observeCommentById(commentId:String, completionHadler:@escaping(_ commentItem:CommentModel) -> Void){
        var ref:DatabaseReference!
        ref = Database.database().reference()
        ref.child("ListComment").child(commentId).observe(.childAdded) { snapshot in
            guard let json = JSON(rawValue: snapshot.value) else {return}
            let comment = CommentModel(json: json)
            completionHadler(comment)
        }
    }
}
