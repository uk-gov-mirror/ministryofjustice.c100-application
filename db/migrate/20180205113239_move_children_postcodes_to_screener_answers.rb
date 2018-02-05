class MoveChildrenPostcodesToScreenerAnswers < ActiveRecord::Migration[5.1]
  def up
    C100Application.all.each do |app|
      app.screener_answers.children_postcodes = app.children_postcodes
      app.screener_answers.save!
    end
  end

  def down
    ScreenerAnswers.all.each do |screener|
      screener_answers.c100_application.children_postcodes = screener_answers.children_postcodes
      screener_answers.c100_application.save!
    end
  end
end
