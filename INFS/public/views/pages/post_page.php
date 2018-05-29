
<link href="/public/css/post-page.css" rel="stylesheet" />
<link href="/public/css/category.css" rel="stylesheet" />
<script src="https://cdn.ckeditor.com/4.9.2/standard-all/ckeditor.js"></script>

<?php require_once "public/views/pages/catpost_header.php" ?>
<main>
    <a href="" class="scrollToTop">
        <img src="/public/img/index/gotop.png" alt="go top btn">
    </a>
    <div class="two-col nowrap">
        <div class="left-col">
            <article class="single-post-block">
                <img src="<?php echo empty($post->imgsrc) ? "/public/img/index/slider-post-black.png" : htmlspecialchars($post->imgsrc); ?>" alt="<?php echo htmlspecialchars($post->heading); ?>" class="head-img" />
                <div class="post-content">
                    <h3><?php echo htmlspecialchars($post->heading); ?></h3>
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
                    <a href="<?php echo htmlspecialchars('/home/categories/' . $post->category->url_name . '/posts/' . $post->url_name . "/"); ?>">8</a>
                    Comments
                    </div>
                    <div class="text">
                    <textarea disabled name="editor1">
                        <?php echo htmlspecialchars($post->text) ?>
                    </textarea>
                        <div class="tags">
                            <div>Tags:</div>
                            <ul>
                                <?php foreach(explode(",", $post->tags) as $tag){?>
                                <li><a href="/home/posts/search/filter=<?php echo htmlspecialchars($tag);?>"><?php echo htmlspecialchars($tag);?></a></li>
                                <?php }?>
                            </ul>
                        </div>
                        <div class="share">
                            <div>Share:</div>
                            <ul>
                                <li>
                                    <a href="https://facebook.com">

                                        <img src="/public/img/index/Facebook-logo-blue.png" alt="Facebook logo">
                                    </a>
                                </li>
                                <li>
                                    <a href="https://twitter.com">

                                        <img src="/public/img/index/Twitter-logo.png" alt="Twitter logo">
                                    </a>
                                </li>
                                <li>
                                    <a href="https://youtube.com">

                                        <img src="/public/img/index/Youtube-logo.png" alt="Youtube logo">
                                    </a>
                                </li>
                                <li>
                                    <a href="https://vimeo.com">

                                        <img src="/public/img/index/Vimeo-logo.png" alt="Vimeo logo">
                                    </a>
                                </li>
                                <li>
                                    <a href="https://pinterest.com">

                                        <img src="/public/img/index/Pinterest-logo.png" alt="Pinterest logo">
                                    </a>
                                </li>
                            </ul>
                        </div>

                        <div class="about-author">
                            <article>
                                <img src="<?php echo htmlspecialchars($post->author->profile_img);?>" alt="title" />
                                <div class="post-content">
                                    <h3><?php echo htmlspecialchars($post->author->first_name . " " . $post->author->second_name)?></h3>
                                    <p>
                                        <?php echo strip_tags($post->author->about);?>
                                    </p>
                                    <ul>
                                        <li>
                                            <a href="https://facebook.com">

                                                <img src="/public/img/index/Facebook-logo-blue.png" alt="Facebook logo">
                                            </a>
                                        </li>
                                        <li>
                                            <a href="https://twitter.com">

                                                <img src="/public/img/index/Twitter-logo.png" alt="Twitter logo">
                                            </a>
                                        </li>
                                        <li>
                                            <a href="https://youtube.com">

                                                <img src="/public/img/index/Youtube-logo.png" alt="Youtube logo">
                                            </a>
                                        </li>
                                        <li>
                                            <a href="https://vimeo.com">

                                                <img src="/public/img/index/Vimeo-logo.png" alt="Vimeo logo">
                                            </a>
                                        </li>
                                        <li>
                                            <a href="https://pinterest.com">

                                                <img src="/public/img/index/Pinterest-logo.png" alt="Pinterest logo">
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </article>
                        </div>

                        <div class="prev-next">
                            <div class="prev">
                                <a href = "<?php echo "/home/categories/". htmlspecialchars($prev_post->category->url_name) . "/posts/" . htmlspecialchars($prev_post->url_name) ?>"><img src="/public/img/index/prev-arrow.png" alt="prev post arrow"></a>
                                <div>
                                    <span>Previous Post</span>
                                    <h3><?php echo htmlspecialchars($prev_post->heading) ?></h3>
                                </div>
                            </div>

                            <div class="next">
                                <div>
                                    <span>Next Post</span>
                                    <h3><?php echo htmlspecialchars($next_post->heading) ?></h3>
                                </div>
                                <a href="<?php echo "/home/categories/". htmlspecialchars($next_post->category->url_name) . "/posts/" . htmlspecialchars($next_post->url_name) ?>"><img src="/public/img/index/next-arrow.png" alt="next post arrow"></a>
                            </div>
                        </div>

                    </div>

                </div>
            </article>
            <section class="category related">
                <div class="category-head">
                    <h2>Related Articles</h2>
                </div>
                <div class="post-block">
                    <ul>
                        <li>
                            <article class="post-preview-large">
                                <img src="<?php echo empty($related_posts[0]->imgsrc) ? "/public/img/index/slider-post-black.png" : htmlspecialchars($related_posts[0]->imgsrc); ?>" alt="<?php echo htmlspecialchars($related_posts[0]->heading); ?>">
                                <div class="post-content">
                                    <h4>
                                        <a class="kinda-blue" href="<?php echo htmlspecialchars("/home/categories/" . $related_posts[0]->category->url_name ."/"); ?>" >
                                            <?php echo htmlspecialchars($related_posts[0]->category->name); ?>
                                        </a>
                                    </h4>
                                    <h3><a href="<?php echo htmlspecialchars('/home/categories/' . $related_posts[0]->category->url_name .'/posts/' .$related_posts[0]->url_name ."/"); ?>"><?php echo htmlspecialchars($related_posts[0]->heading); ?></a></h3>
                                    <div class="post-metadata">
                                        <time datetime="<?php echo htmlspecialchars($related_posts[0]->time); ?>">
                                            <?php echo (new DateTime($related_posts[0]->time))->format('F d, Y'); ?>
                                        </time>
                                        <div class="author">
                                            by
                                            <a rel="author" href="<?php echo htmlspecialchars("/home/posts/by=" . $related_posts[0]->author->id ."/"); ?>">
                                                <?php echo htmlspecialchars($related_posts[0]->author->first_name . " " . $related_posts[0]->author->second_name); ?>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </article>
                        </li>
                        <li>
                            <article class="post-preview-large">
                                <img src="<?php echo empty($related_posts[1]->imgsrc) ? "/public/img/index/slider-post-black.png" : htmlspecialchars($related_posts[1]->imgsrc); ?>" alt="<?php echo htmlspecialchars($related_posts[1]->heading); ?>">
                                <div class="post-content">
                                    <h4>
                                        <a class="kinda-blue" href="<?php echo htmlspecialchars("/home/categories/" . $related_posts[1]->category->url_name ."/"); ?>" >
                                            <?php echo htmlspecialchars($related_posts[1]->category->name); ?>
                                        </a>
                                    </h4>
                                    <h3><a href="<?php echo htmlspecialchars('/home/categories/' . $related_posts[1]->category->url_name .'/posts/' .$related_posts[1]->url_name ."/"); ?>"><?php echo htmlspecialchars($related_posts[1]->heading); ?></a></h3>
                                    <div class="post-metadata">
                                        <time datetime="<?php echo htmlspecialchars($related_posts[1]->time); ?>">
                                            <?php echo (new DateTime($related_posts[1]->time))->format('F d, Y'); ?>
                                        </time>
                                        <div class="author">
                                            by
                                            <a rel="author" href="<?php echo htmlspecialchars("/home/posts/by=" . $related_posts[1]->author->id ."/"); ?>">
                                                <?php echo htmlspecialchars($related_posts[1]->author->first_name . " " . $related_posts[1]->author->second_name); ?>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </article>
                        </li>
                    </ul>
                </div>
            </section>
            <section class="category comments">
                <div class="category-head">
                    <h2><?php echo count(Commentary::get_by_post_id($post->id))?> Comments</h2>
                </div>
                <div class="comment-section">
                    <ul>
                        <?php foreach($root_comments as $rcom){
                            load_comment($rcom);
                        } ?>                        
                    </ul>
                </div>
            </section>

            <section class="category reply">
                <div class="category-head">
                    <h2>Leave a Reply</h2>
                </div>
                <div class="reply-to-person" style="display:none"><span class="name-hold"></span><span class="remove-reply">X</span></div>
                <form id="commentForm" action="/commentary/add_new/" method="post">
                    <input type="hidden" name="post_id" value="<?php echo $post->id?>">
                    <input type="hidden" name="reply_id" value="">
                    <textarea required name="text" placeholder="Your comment here"></textarea>
                    <?php if (!isset($_SESSION['logged_in'])) { ?>
                        <div>
                            <input required type="text" name="name" placeholder="Your name">
                            <input required type="email" name="email" placeholder="Your email">
                        </div>           
                    <?php } else {?>
                        <input type="hidden" name="user_id" value="<?php echo unserialize($_SESSION['current_user'])->id?>">
                    <?php }?>
                    <button type="submit">Submit</button>
                </form>
            </section>
        </div>

        <?php require_once "public/views/pages/common_aside.php" ?>
    </div>

</main>

<footer>
    <div class="footer-container">
        <div class="footer-content">

            <section class="footer-info">
                <div class="logo">
                    <a href="/home/">
                        <h2>
                            <span class="logo-express white">Express</span>
                            <span class="logo-blog kinda-blue">Blogs & Magazines</span>
                        </h2>
                    </a>
                </div>

                <p>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tincidunt tellus lacus. Duis quis mi ante.
                </p>

            </section>

            <section class="footer-useful-links">
                <div class="category-head">
                    <h2>Useful Links</h2>
                </div>
                <ul>
                    <li>
                        <a href="/home/">Home 1</a>
                    </li>
                    <li>
                        <a href="/home/">Home 2</a>
                    </li>
                    <li>
                        <a href="/home/">Home 3</a>
                    </li>
                    <li>
                        <a href="/home/">Home 4</a>
                    </li>
                    <li>
                        <a href="/home/">Home 5</a>
                    </li>
                </ul>
            </section>

            <section class="footer-follow">
                <div class="category-head">
                    <h2>Follow Us</h2>
                </div>

                <ul>
                    <li>
                        <a href="https://facebook.com">
                            <div>
                                <img src="/public/img/index/Facebook-logo-blue.png" alt="Facebook logo">
                            </div> facebook</a>
                    </li>
                    <li>
                        <a href="https://twitter.com">
                            <div>
                                <img src="/public/img/index/Twitter-logo-white.png" alt="Twitter logo">
                            </div> Twitter</a>
                    </li>
                    <li>
                        <a href="https://youtube.com">
                            <div>
                                <img src="/public/img/index/Youtube-logo-white.png" alt="Youtube logo">
                            </div> Youtube</a>
                    </li>
                    <li>
                        <a href="https://vimeo.com">
                            <div>
                                <img src="/public/img/index/Vimeo-logo-white.png" alt="Vimeo logo">
                            </div> Vimeo</a>
                    </li>
                    <li>
                        <a href="https://pinterest.com">
                            <div>
                                <img src="/public/img/index/Pinterest-logo-white.png" alt="Pinterest logo">
                            </div> Pinterest</a>
                    </li>
                </ul>
            </section>

            <section class="footer-newsletter">
                <div class="category-head">
                    <h2>Newsletter</h2>
                </div>

                <form>
                    <input type="email" name="mail" placeholder="Email">
                    <button type="submit">Subscribe</button>
                </form>
            </section>

        </div>
        <div class="copyright">&copy; Copyright Gomalthemes 2017, All Rights Reserved</div>
    </div>
</footer>
<script src="/public/js/post-page.js"></script>