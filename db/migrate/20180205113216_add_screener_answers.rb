class AddScreenerAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :screener_answers do |t|
      t.string :children_postcodes, null: true
    end

    add_reference :screener_answers, :c100_application, type: :uuid, foreign_key: true
  end
end
