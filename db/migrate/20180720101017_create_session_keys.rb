class CreateSessionKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :session_keys do |t|
      t.string :rdSession
      t.string :session_key
      t.string :openId
      t.string :pubKey
      t.string :rdSession_key
      t.string :rdSession_iv
      t.string :rdSession_final

      t.timestamps
    end
  end
end
