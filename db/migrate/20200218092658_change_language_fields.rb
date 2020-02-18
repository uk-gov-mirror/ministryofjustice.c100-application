class ChangeLanguageFields < ActiveRecord::Migration[5.2]
  def up
    CourtArrangement.update_all(language_interpreter: nil)

    remove_column :court_arrangements, :sign_language_interpreter
    remove_column :court_arrangements, :welsh_language

    rename_column :court_arrangements, :language_interpreter, :language_options

    # 2-steps change because otherwise cast will fail even tho we don't care about data being lost
    change_column :court_arrangements, :language_options, :string
    change_column :court_arrangements, :language_options, :string, array: true, default: [], using: "string_to_array(language_options, ',')"
  end
end
