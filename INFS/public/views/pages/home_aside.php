<aside>

    <section class="category recent">
        <div class="category-head">
            <h2>Recent Posts</h2>
        </div>
        <div class="post-block">
            <ul>
                <li>
                    <article class="post-preview">
                        
                    </article>
                </li>

                <li>
                    <article class="post-preview">
                        
                    </article>
                </li>
                <li>
                    <article class="post-preview">
                        
                    </article>
                </li>
                <li>
                    <article class="post-preview">
                        
                    </article>
                </li>
            </ul>
        </div>
    </section>

    <section class="categories">
        <div class="category-head">
            <h2>Categories</h2>
        </div>
        <ul>
            <?php foreach(array_filter(Category::all(), function($cat){
                return empty($cat->parent_name);
            }) as $category){ 
                ?>
            <li>
                <a href="<?php echo htmlspecialchars("/home/categories/" . $category->url_name ."/")?>"><h4><?php echo htmlspecialchars($category->name)?></h4></a>
                <div><?php echo count(Post::get_by_category($category->id));?> posts</div>
            </li>
            <?php }?>           
        </ul>
    </section>

    <div class="banner">
        <img src="/public/img/index/slider-post-black.png" alt="title" />
    </div>
</aside>