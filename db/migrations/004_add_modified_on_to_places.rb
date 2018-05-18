# frozen_string_literal: true
Sequel.migration do
  change do
    alter_table :places do
      add_column :modified_on, Date
    end
  end
end
