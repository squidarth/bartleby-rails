$files = Dir.glob("#{Rails.root}/app/controllers/**/*")
$files += Dir.glob("#{Rails.root}/app/models/**/*")

$new_binding = $old_binding = Hash.new
