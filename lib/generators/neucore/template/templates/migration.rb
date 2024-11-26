class Create<%= resource.pluralize %> < ActiveRecord::Migration[7.2]
  def change
    create_table :<%= resource.tableize %> do |t|
      t.string :name

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
