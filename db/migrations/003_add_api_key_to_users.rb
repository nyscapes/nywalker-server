# frozen_string_literal: true
Sequel.migration do
  change do
    alter_table :users do
      add_column :api_key, String
    end
  end
end
