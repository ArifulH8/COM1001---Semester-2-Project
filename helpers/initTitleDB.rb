require "require_all"

require_rel "../db/db"
require_rel "../models"

def init_db_title
  puts "Running DB Init"
  ENV["APP_ENV"] = "test"
  dataset = DB[:titles]
  dataset.delete

  titles_list = %w[Mr Mrs Ms Dr]
  titles_list.each do |title|
    title_record = Title.new
    title_record.load(title)
    title_record.save_changes
  end
  puts "Finished titleDB Init"
end

init_db_title if $PROGRAM_NAME == __FILE__