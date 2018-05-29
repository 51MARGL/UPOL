<img src="<?php echo empty($post->imgsrc) ? "/public/img/index/slider-post-black.png" : htmlspecialchars($post->imgsrc); ?>" alt="<?php echo htmlspecialchars($post->heading); ?>">
<div class="post-content">
    <h3><a href="<?php echo htmlspecialchars('/home/categories/' . $post->category->url_name . '/posts/' . $post->url_name . "/"); ?>"><?php echo htmlspecialchars($post->heading); ?></a></h3>
    <div class="post-metadata">
        <time datetime="<?php echo htmlspecialchars($post->time); ?>">
            <?php echo (new DateTime($post->time))->format('F d, Y'); ?>
        </time>
        <div class="author">
            by
            <a rel="author" href="<?php echo htmlspecialchars("/home/posts/by=" . $post->author->id . "/"); ?>">
                <?php echo htmlspecialchars($post->author->first_name . " " . $post->author->second_name); ?>
            </a>
        </div>
        <a href="<?php echo htmlspecialchars('/home/categories/' . $post->category->url_name . '/posts/' . $post->url_name . "/"); ?>"><?php echo count(Commentary::get_by_post_id($post->id))?></a>
        Comments
    </div>
    <p>
        <?php echo htmlspecialchars(substr(strip_tags($post->text), 0, 250) . "..."); ?>
    </p>
    <a class="read-more" href="<?php echo htmlspecialchars('/home/categories/' . $post->category->url_name . '/posts/' . $post->url_name . "/"); ?>">
        Read More
    </a>
</div>