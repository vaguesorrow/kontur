class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles, id: :bigint do |t|
      t.references :user, type: :bigint, null: false, foreign_key: true, index: { unique: true }
      t.string :display_name, null: false
      t.string :avatar_url
      t.text :bio

      t.timestamps
    end
  end
end
