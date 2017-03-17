module CommonFunctions
  def create_tags(tags_list, website_id)
    @tags_array = tags_list.split(/\s*,\s*/)

    @tags_array.each do |tag|
    	@new_tag = Tag.new(website_id: website_id, title: tag)
    	@new_tag.save
    end

  end
end