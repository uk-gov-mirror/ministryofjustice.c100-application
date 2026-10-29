class CreateCourtfinderToken < ActiveRecord::Migration[8.1]
  def change
    create_table :courtfinder_tokens, id: :uuid do |t|
      t.string :access_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
