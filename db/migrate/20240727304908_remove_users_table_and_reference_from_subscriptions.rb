# frozen_string_literal: true

class RemoveUsersTableAndReferenceFromSubscriptions < ActiveRecord::Migration[7.0]
  def change
    # Remove the foreign key constraint
    remove_foreign_key :subscriptions, :users

    # Remove the user_id column from subscriptions table
    remove_reference :subscriptions, :user, index: true

    # Drop the users table
    drop_table :users
  end
end
