# frozen_string_literal: true
Sequel.migration do
  change do
    alter_table :users do
      add_column :enabled, TrueClass, default: false 
    end
  end
end
