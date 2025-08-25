Jekyll::Hooks.register :posts, :pre_render do |post|
  if post.data['tags']
    post.data['tags'] = post.data['tags'].map do |tag|
      # If tag is all uppercase, keep it
      if tag == tag.upcase
        tag
      else
        # If tag has mixed case (starts with uppercase and contains lowercase), make it lowercase
        if tag.match?(/\A[A-Z][a-z]/)
          tag.downcase
        else
          tag
        end
      end
    end
  end

  if post.data['categories']
    post.data['categories'] = post.data['categories'].map do |category|
      if category == category.upcase
        category
      else
        if category.match?(/\A[A-Z][a-z]/)
          category.downcase
        else
          category
        end
      end
    end
  end
end
# This plugin normalizes tags and categories in posts.