<img src="<?php echo $post->imgsrc; ?>" alt="<?php echo $post->heading; ?>">
<div class="post-content">
    <h3><a href="/post_page/"><?php echo $post->heading; ?></a></h3>
    <div class="post-metadata">
        <time datetime="<?php echo $post->time; ?>">
            <?php echo (new DateTime($post->time))->format('F d, Y'); ?>
        </time>
        <div class="author">
            by
            <a rel="author" href="<?php echo "/category/by " . $post->author ."/"; ?>">
                <?php echo $post->author; ?>
            </a>
        </div>
        <a href="/post_page/">8</a>
        Comments
    </div>
    <p>
        <?php echo substr($post->text,0,250) . "..."; ?>
    </p>
    <button>
        <a href="/post_page/">Read More</a>
    </button>
</div>