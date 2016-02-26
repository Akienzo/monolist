class Ownership < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :item, class_name: "Item"
end
#ユーザーと、アイテムへの参照を持たせることで、「あるユーザーがあるアイテムを所有している」ということを表現する
#Ownershipモデルは、usersテーブルとitemsテーブルの中間テーブルであるownershipsテーブルを使い、ownershipsテーブルには、user_idとitem_idが含まれる。
