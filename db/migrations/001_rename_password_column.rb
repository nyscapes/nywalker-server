# frozen_string_literal: true
Sequel.migration do
  change do
    alter_table(:users) do
        rename_column :password, :password_digest
    end
  end
end
