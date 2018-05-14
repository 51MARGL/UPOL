<img src="<?php echo $post->imgsrc; ?>" alt="<?php echo $post->heading; ?>">
<div class="post-content">
    <h4>
        <a class="kinda-blue" href="<?php echo "/category/" . $post->category ."/"; ?>" >
            <?php echo $post->category; ?>
        </a>
    </h4>
    <h3><a href="/post_page/"><?php echo $post->heading; ?></a></h3>
    <div class="post-metadata">
        <time datetime="<?php echo $post->time; ?>">
            <?php echo (new DateTime($post->time))->format('F d, Y'); ?>
        </time>
        <div class="author">
            by
            <a rel="author" href="<?php echo "/category/by" . str_replace(" ", "", $post->author) ."/"; ?>">
                <?php echo $post->author; ?>
            </a>
        </div>
    </div>
</div>
