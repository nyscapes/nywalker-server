# frozen_string_literal: true
Sequel.migration do
  change do
    create_table(:books) do
      primary_key :id
      String :slug, :size=>2000
      String :author, :size=>50
      String :title, :text=>true
      String :isbn, :size=>50
      Integer :year
      String :url, :size=>2000
      String :cover, :size=>2000
      Date :added_on
      Date :modified_on
    end
    
    create_table(:bounding_boxes, :ignore_index_errors=>true) do
      primary_key :id
      Integer :place_id, :null=>false
      String :place_slug, :size=>50, :null=>false
      
      index [:place_id, :place_slug], :name=>:index_bounding_boxes_place
    end
    
    create_table(:flags, :ignore_index_errors=>true) do
      primary_key :id
      String :comment, :text=>true
      String :object_type, :size=>50
      Integer :object_id
      Date :added_on
      Integer :user_id, :null=>false
      
      index [:user_id], :name=>:index_flags_user
    end
    
    create_table(:spatial_ref_sys) do
      Integer :srid, :null=>false
      String :auth_name, :size=>256
      Integer :auth_srid
      String :srtext, :size=>2048
      String :proj4text, :size=>2048
      
      primary_key [:srid]
    end
    
    create_table(:specials, :ignore_index_errors=>true) do
      primary_key :id
      String :field, :size=>50
      String :help_text, :text=>true
      Integer :book_id, :null=>false
      
      index [:book_id], :name=>:index_specials_book
    end
    
    create_table(:users) do
      primary_key :id
      String :name, :size=>50
      String :email, :size=>50
      String :username, :size=>50
      String :password, :size=>60
      TrueClass :admin, :default=>false
      Date :added_on
      Date :modified_on
      String :firstname, :size=>50
      String :lastname, :size=>50
    end
    
    create_table(:book_users) do
      foreign_key :book_id, :books, :null=>false, :key=>[:id]
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      
      primary_key [:book_id, :user_id]
    end
    
    create_table(:places, :ignore_index_errors=>true) do
      primary_key :id
      String :slug, :size=>2000
      String :name, :size=>50
      Date :added_on
      Float :lat
      Float :lon
      String :confidence, :size=>50
      String :source, :text=>true
      String :geonameid, :size=>50
      String :what3word, :size=>50
      String :bounding_box_string, :text=>true
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      TrueClass :flagged
      String :note, :text=>true
      String :geom
      
      index [:user_id], :name=>:index_places_user
    end
    
    create_table(:instances, :ignore_index_errors=>true) do
      primary_key :id
      Integer :page
      Integer :sequence
      String :text, :text=>true
      Date :added_on
      Date :modified_on
      foreign_key :place_id, :places, :null=>false, :key=>[:id]
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      foreign_key :book_id, :books, :null=>false, :key=>[:id]
      TrueClass :flagged
      String :note, :text=>true
      String :special, :text=>true
      
      index [:book_id], :name=>:index_instances_book
      index [:place_id], :name=>:index_instances_place
      index [:user_id], :name=>:index_instances_user
    end
    
    create_table(:nicknames, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>50
      foreign_key :place_id, :places, :null=>false, :key=>[:id]
      Integer :instance_count
      
      index [:place_id], :name=>:index_nicknames_place
    end
  end
end
