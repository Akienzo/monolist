class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:asin]
      #Itemをasinという値で検索して、存在する場合はそのデータを返し、それ以外は与えた値(今回はasin)でItem.newした状態のItemモデルを返します。
      @item = Item.find_or_initialize_by(asin: params[:asin])
    else
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合はAmazonのデータを登録する。
    if @item.new_record?
      #begin～rescue～endで囲われた部分は例外処理を行っています。begin〜rescueで囲まれた箇所のコードを実行している時にエラーが発生した場合に例外を取得する
      begin
        # TODO 商品情報の取得 Amazon::Ecs.item_lookupを用いてください
        response = {}
      #rescue Amazon::RequestError => eと記述することにより、Amazon::RequestErrorが発生した場合には変数eにエラーオブジェクトを格納し、rescue〜endの部分が実行されます。
      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end

      amazon_item       = response.items.first
      @item.title        = amazon_item.get('ItemAttributes/Title')
      @item.small_image  = amazon_item.get("SmallImage/URL")
      @item.medium_image = amazon_item.get("MediumImage/URL")
      @item.large_image  = amazon_item.get("LargeImage/URL")
      @item.detail_page_url = amazon_item.get("DetailPageURL")
      @item.raw_info        = amazon_item.get_hash
      @item.save!
    end

    # TODO ユーザにwant or haveを設定する
    # params[:type]の値ににHaveボタンが押された時には「Have」,
    # Wantボタンがされた時には「Want」が設定されています。
    

  end

  def destroy
    @item = Item.find(params[:item_id])

    # TODO 紐付けの解除。 
    # params[:type]の値ににHavedボタンが押された時には「Have」,
    # Wantedボタンがされた時には「Want」が設定されています。

  end
end
