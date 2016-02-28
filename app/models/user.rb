class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower
  
  #has_many :items, through: :ownerships、Itemモデルではhas_many :users, through: :ownershipsとなっていて、
  #:ownershipsを参照することで、それぞれ:itemsと:usersを取得している。
  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :items ,through: :ownerships
  #has_many :ownershipsとは異なり、has_many :wantsではclass_name: "Want"を指定することで、ownershipsテーブルからtypeがWantであるものを取得します。
  #このことにより、has_many :want_itemsで、wantしたアイテムの一覧を取得することができる。
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_items , through: :wants, source: :item
  #ownershipsテーブルからtypeがHaveであるものの一覧がhavesで、Haveしたアイテムの一覧がhave_itemsで取得できるようになります。
  #source: :itemとしているのは、through: :havesで指定した参照先のクラスHaveに宣言されているbelongs_to :itemのitemを取得することを意味しています
  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items , through: :haves, source: :item

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end

  ## TODO 実装
  def have(item)
    haves.find_or_create_by(item_id:item.id)
  end

  def unhave(item)
    have = haves.find_by(item_id:item.id)
    have.destroy if have
  end

  def have?(item)
    have_items.include?(item)
  end

  def want(item)
    # want.rbに紐づけるのかなと上記でhas_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroyとあるのでwantsかなと考えました
    wants.find_or_create_by(item_id:item.id)
  end

  def unwant(item)
    want = wants.find_by(item_id:item.id)
    want.destroy if want
  end

  def want?(item)
    want_items.include?(item)
  end
end

# has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
# has_many :want_items , through: :wants, source: :item
# ここで、has_many :ownershipsとは異なり、has_many :wantsではclass_name: "Want"を指定することで、ownershipsテーブルからtypeがWantであるものを取得します。
# このことにより、has_many :want_itemsで、wantしたアイテムの一覧を取得することができます。
 # 他のユーザーをフォローする 現在のユーザーのfollowing_relationshipsの中からフォローするユーザーのuser_idを含むものを探し、存在しない場合は、新しく作成します。
    # def follow(other_user)
    #   following_relationships.find_or_create_by(followed_id: other_user.id)
    #   #数のパラメータと一致するものを1件取得し、存在する場合はそのオブジェクトを返し、存在しない場合は引数の内容で新しくオブジェクトを作成し、データベースに保存します。
    # end
  
    # # フォローしているユーザーをアンフォローする following_relationshipsからフォローしているユーザーのuser_idが入っているものを探し、存在する場合は削除します
    # def unfollow(other_user)
    #   following_relationship = following_relationships.find_by(followed_id: other_user.id)
    #   following_relationship.destroy if following_relationship
    # end
    
    # def have(item)
    # haves.find_or_create_by(item_id: item.id)
    # end