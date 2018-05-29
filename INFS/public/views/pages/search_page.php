
<link href="/public/css/category.css" rel="stylesheet" />

<?php require_once "public/views/pages/catpost_header.php" ?>

<main>
    <a href="" class="scrollToTop">
        <img src="/public/img/index/gotop.png" alt="go top btn">
    </a>
    <div class="two-col nowrap">
        <div class="left-col">
            <div class="post-block">
                <ul class="post-list">
<?php foreach ($postsToDisplay as $post) {?>

<li>
   <article class='post-preview-detailed'>
        <?php require("public/views/posts/getSingleDetailed.php");?>
   </article>
</li>
<?php }?>
                </ul>
                <div class="page-list">
                    <?php require_once "admin/views/pages/pagination.php"?>
                </div>
            </div>
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

                <ul class="twitter-list">
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

<script src="/admin/js/autocomplete.js"></script>
<script src="/public/js/search.js"></script>
