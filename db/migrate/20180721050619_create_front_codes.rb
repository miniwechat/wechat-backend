class CreateFrontCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :front_codes do |t|
      t.string :grant_type
      t.string :jsCode

      t.timestamps
    end
  end
end
