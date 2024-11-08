json.column_titles columns do |column|
  json.name model_name.classify.constantize.human_attribute_name(column)
  json.key column
  if defined?(image_type) && image_type.include?(column)
    json.type "image"
  elsif defined?(video_type) && video_type.include?(column)
    json.type 'video'
  elsif defined?(color_type) && color_type.include?(column)
    json.type 'color'
  elsif defined?(rich_text_type) && rich_text_type.include?(column)
    json.type "rich_text"
  elsif defined?(switch_type) && switch_type.include?(column)
    json.type "switch"
  elsif defined?(rich_text_ml_type) && rich_text_ml_type.include?(column)
    json.type "rich_text_ml"
  elsif defined?(qrcode_type) && qrcode_type.include?(column)
    json.type "qrcode"
  elsif defined?(ml_type) && ml_type.include?(column)
    json.type "ml"
  elsif defined?(tag_type) && tag_type.include?(column)
    json.type 'tag'
  elsif defined?(dynamic_type) && dynamic_type.include?(column)
    json.type 'dynamic'
  elsif defined?(member_actions_type) && member_actions_type.include?(column)
    json.type 'member_actions'
  elsif defined?(section_type) && section_type.include?(column)
    json.type 'section'
  end

  if defined?(widths) && widths[column.to_sym]
    json.width widths[column.to_sym]
  end
end
