class RenameAccessTokenToEncryptedAccessTokenInCourtfinderTokens < ActiveRecord::Migration[8.1]
  def change
    rename_column :courtfinder_tokens, :access_token, :encrypted_access_token
  end
end
