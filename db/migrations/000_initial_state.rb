# frozen_string_literal: true
Sequel.migration do
# frozen_string_literal: true
  change do
# frozen_string_literal: true
    create_table(:books) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      String :slug, :size=>2000
# frozen_string_literal: true
      String :author, :size=>50
# frozen_string_literal: true
      String :title, :text=>true
# frozen_string_literal: true
      String :isbn, :size=>50
# frozen_string_literal: true
      Integer :year
# frozen_string_literal: true
      String :url, :size=>2000
# frozen_string_literal: true
      String :cover, :size=>2000
# frozen_string_literal: true
      Date :added_on
# frozen_string_literal: true
      Date :modified_on
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:bounding_boxes, :ignore_index_errors=>true) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      Integer :place_id, :null=>false
# frozen_string_literal: true
      String :place_slug, :size=>50, :null=>false
# frozen_string_literal: true
      
# frozen_string_literal: true
      index [:place_id, :place_slug], :name=>:index_bounding_boxes_place
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:flags, :ignore_index_errors=>true) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      String :comment, :text=>true
# frozen_string_literal: true
      String :object_type, :size=>50
# frozen_string_literal: true
      Integer :object_id
# frozen_string_literal: true
      Date :added_on
# frozen_string_literal: true
      Integer :user_id, :null=>false
# frozen_string_literal: true
      
# frozen_string_literal: true
      index [:user_id], :name=>:index_flags_user
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:spatial_ref_sys) do
# frozen_string_literal: true
      Integer :srid, :null=>false
# frozen_string_literal: true
      String :auth_name, :size=>256
# frozen_string_literal: true
      Integer :auth_srid
# frozen_string_literal: true
      String :srtext, :size=>2048
# frozen_string_literal: true
      String :proj4text, :size=>2048
# frozen_string_literal: true
      
# frozen_string_literal: true
      primary_key [:srid]
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:specials, :ignore_index_errors=>true) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      String :field, :size=>50
# frozen_string_literal: true
      String :help_text, :text=>true
# frozen_string_literal: true
      Integer :book_id, :null=>false
# frozen_string_literal: true
      
# frozen_string_literal: true
      index [:book_id], :name=>:index_specials_book
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:users) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      String :name, :size=>50
# frozen_string_literal: true
      String :email, :size=>50
# frozen_string_literal: true
      String :username, :size=>50
# frozen_string_literal: true
      String :password, :size=>60
# frozen_string_literal: true
      TrueClass :admin, :default=>false
# frozen_string_literal: true
      Date :added_on
# frozen_string_literal: true
      Date :modified_on
# frozen_string_literal: true
      String :firstname, :size=>50
# frozen_string_literal: true
      String :lastname, :size=>50
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:book_users) do
# frozen_string_literal: true
      foreign_key :book_id, :books, :null=>false, :key=>[:id]
# frozen_string_literal: true
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
# frozen_string_literal: true
      
# frozen_string_literal: true
      primary_key [:book_id, :user_id]
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:places, :ignore_index_errors=>true) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      String :slug, :size=>2000
# frozen_string_literal: true
      String :name, :size=>50
# frozen_string_literal: true
      Date :added_on
# frozen_string_literal: true
      Float :lat
# frozen_string_literal: true
      Float :lon
# frozen_string_literal: true
      String :confidence, :size=>50
# frozen_string_literal: true
      String :source, :text=>true
# frozen_string_literal: true
      String :geonameid, :size=>50
# frozen_string_literal: true
      String :what3word, :size=>50
# frozen_string_literal: true
      String :bounding_box_string, :text=>true
# frozen_string_literal: true
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
# frozen_string_literal: true
      TrueClass :flagged
# frozen_string_literal: true
      String :note, :text=>true
# frozen_string_literal: true
      String :geom
# frozen_string_literal: true
      
# frozen_string_literal: true
      index [:user_id], :name=>:index_places_user
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:instances, :ignore_index_errors=>true) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      Integer :page
# frozen_string_literal: true
      Integer :sequence
# frozen_string_literal: true
      String :text, :text=>true
# frozen_string_literal: true
      Date :added_on
# frozen_string_literal: true
      Date :modified_on
# frozen_string_literal: true
      foreign_key :place_id, :places, :null=>false, :key=>[:id]
# frozen_string_literal: true
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
# frozen_string_literal: true
      foreign_key :book_id, :books, :null=>false, :key=>[:id]
# frozen_string_literal: true
      TrueClass :flagged
# frozen_string_literal: true
      String :note, :text=>true
# frozen_string_literal: true
      String :special, :text=>true
# frozen_string_literal: true
      
# frozen_string_literal: true
      index [:book_id], :name=>:index_instances_book
# frozen_string_literal: true
      index [:place_id], :name=>:index_instances_place
# frozen_string_literal: true
      index [:user_id], :name=>:index_instances_user
# frozen_string_literal: true
    end
# frozen_string_literal: true
    
# frozen_string_literal: true
    create_table(:nicknames, :ignore_index_errors=>true) do
# frozen_string_literal: true
      primary_key :id
# frozen_string_literal: true
      String :name, :size=>50
# frozen_string_literal: true
      foreign_key :place_id, :places, :null=>false, :key=>[:id]
# frozen_string_literal: true
      Integer :instance_count
# frozen_string_literal: true
      
# frozen_string_literal: true
      index [:place_id], :name=>:index_nicknames_place
# frozen_string_literal: true
    end
# frozen_string_literal: true
  end
# frozen_string_literal: true
end
