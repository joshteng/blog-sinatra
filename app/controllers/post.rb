namespace '/posts' do
  get '/new' do
    @tags = Tag.all
    erb :"posts/new"
  end

  get '/?' do
    if params[:tag]
      tag = Tag.find(params[:tag])
      @posts = tag.posts
    else
      @posts = Post.all
    end
    erb :"posts/index"
  end

  get '/:id/?' do
    @post = Post.find(params[:id])
    erb :"posts/show"
  end

  get '/:id/edit/?' do
    @tags = Tag.all
    @post = Post.find(params[:id])
    erb :"posts/edit"
  end

  #make new post
  post '/?' do
    @post = Post.new(params[:post])

    tag_ids = params[:tag_ids] || []
    tag_ids = create_new_tag(tag_ids, params[:new_tag])
    append_tags(@post, tag_ids)

    if @post.save
      redirect "/posts/#{@post.id}"
    else
      erb :"post/new"
    end
  end

  #update existing post
  put '/:id/?' do
    @post = Post.find(params[:id])

    @post.update_attributes(params[:post])

    tag_ids = params[:tag_ids] || []
    tag_ids = create_new_tag(tag_ids, params[:new_tag])
    append_tags(@post, tag_ids)

    redirect "/posts/#{@post.id}"
  end

  #delete existing post
  delete '/:id/?' do
    Post.delete(params[:id])
    redirect '/'
  end


end



####To move these methods into the model
def create_new_tag(tag_ids, tag_title)
  tag_ids << Tag.create(title: tag_title).id unless tag_title.empty?
  tag_ids
end

def append_tags(post, tag_ids)
  if tag_ids
    tag_ids.each do |id|
      puts post.tag_ids.inspect
      post.tags << Tag.find(id) unless post.tag_ids.include?(id.to_i)
    end
  end
end
