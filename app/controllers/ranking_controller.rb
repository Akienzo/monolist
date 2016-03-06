class RankingController < ApplicationController
    
 def want
   #@items = Item.group(:wants)
   #@item_counts = Want.group(:item_id).order('count_item_id desc').limit(10).count('item_id').keys
   @item_counts = Want.group(:item_id).order('count_item_id desc').limit(10).count('item_id')
   item_ids = @item_counts.keys
   #@items_with_count = @item_counts.collect { |id, count| [Item.find(id), count] }
   @items = Item.where(id: item_ids)
   #item_ids = @item_counts.collect(&:item_id)
   #@items = Item.where('id IN(?)', @item_counts.collect(&:item_id))
   #@items = Item.find(params[:item_id])
   #@items = find(params[:id])
   #@items = Item.find(:item_id)
   #@items = Item.find(:id)
   #@items = Item.find([:item_id])
   #@items = Item.collect {|item| }
   #@items = Item.where
   #@items = Item.where('item_id IN(?)', collect(&:item_id))
   #@items = Item.find(:alls)
   #@items = Item.find(1)
   
   #Item.find_by_sql("SELECT * Item WHERE column1 = 'column1'")
   #Item.where(email: 'test@example.com').all
   #@items = Item.find_by_sql("SELECT * from Item")
   #@items = Item.pluck(:id, :asin, :title, :description, :detail_page_url, :small_image, :medium_image, :large_image, :raw_info, :created_at, :updated_at )
    #@items = Item.find(:all, :group => "item_id")
   #@item_counts = Want.group(:item_id).order('count_item_id desc').limit(10).count('item_id')
   #@items = Item.find(@item_counts).sort_by {|itemc| @item_counts.index(itemc.id)}
   #binding.pry
#   @item_counts.transform_keys!{ |key| Item.find(key) }
 end
 
 def have
   @item_counts = Have.group(:item_id).order('count_item_id desc').limit(10).count('item_id')
   item_ids = @item_counts.keys
   @items = Item.where(id: item_ids)
   #@items = Item.find(params[:item_id])
 end
 
  
end

