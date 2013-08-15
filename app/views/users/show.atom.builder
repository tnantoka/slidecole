atom_feed do |feed|
  feed.title("#{@user.username} - #{t(:newer_slides)} - #{t(:brand)}")
  feed.updated(@slides[0].created_at) if @slides.length > 0

  @slides.each do |slide|
    feed.entry(slide, url: user_slide_url(@user, slide)) do |entry|
      entry.title(slide.title)

      entry.content(slide.summary, type: 'html')

      entry.author do |author|
        author.name(@user.username)
      end
    end
  end
end
