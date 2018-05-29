<aside>
            <section class="category">
                <div class="category-head">
                    <h2>Social Profiles</h2>
                </div>
                <ul class="social-blocks">
                    <li>
                        <div class="rect-fb">
                            <img src="/public/img/index/Facebook-logo-white.png" alt="facebook logo">
                        </div>
                        <h3>
                            5,807
                        </h3>
                        <p>
                            Followers
                        </p>
                    </li>

                    <li>
                        <div class="rect-tw">
                            <img src="/public/img/index/Twitter-logo-white.png" alt="Twitter logo">
                        </div>
                        <h3>
                            1,487
                        </h3>
                        <p>
                            Followers
                        </p>
                    </li>
                    <li>
                        <div class="rect-you">
                            <img src="/public/img/index/Youtube-logo-white.png" alt="Youtube logo">
                        </div>
                        <h3>
                            2,247
                        </h3>
                        <p>
                            Followers
                        </p>
                    </li>
                    <li>
                        <div class="rect-inst">
                            <img src="/public/img/index/Instagram-logo-white.png" alt="Instagram logo">
                        </div>
                        <h3>
                            9,874
                        </h3>
                        <p>
                            Followers
                        </p>
                    </li>

                </ul>
            </section>

            <section class="category">
                <div class="category-head">
                    <h2>Subscribe</h2>
                </div>
                <form class="subscribe-form">
                    <label for="mail">Subscribe to our newsletter</label>
                    <div>
                        <input type="email" name="mail" id="mail" placeholder="Email">
                        <button type="submit">Subscribe</button>
                    </div>
                    <label for="mail" class="under">Don't worry we don't spam</label>
                </form>
            </section>



            <section class="category whats-hot">
                <div class="category-head">
                    <h2>What's Hot</h2>
                </div>
                <div class="post-block">
                    <ul>
                    <?php foreach ($most_hot as $post) { ?>                        
                            <li>
                                <article class="post-preview-large">
                                    <?php require("public/views/posts/getSingleDetailed.php");?>
                                </article>
                            </li>
                        <?php } ?>                       
                    </ul>
                </div>
            </section>

            <section class="category most-popular">
                <div class="category-head">
                    <h2>Most Popular</h2>
                </div>
                <div class="post-block">
                    <ul>
                        <?php foreach ($most_viewed as $post) { ?>                        
                            <li>
                                <article class="post-preview bordered">
                                    <?php require("public/views/posts/getSingle.php");?>
                                </article>
                            </li>
                        <?php } ?>
                    </ul>
                </div>
            </section>

            <section class="category inst">
                <div class="category-head">
                    <h2>Instagram</h2>
                </div>
                <div class="inst-container">
                    <ul>
                        <li>
                            <img src="/public/img/index/slider-post-black.png" alt="instagram-foto">
                        </li>
                        <li>
                            <img src="/public/img/index/slider-post-black.png" alt="instagram-foto">
                        </li>
                        <li>
                            <img src="/public/img/index/slider-post-black.png" alt="instagram-foto">
                        </li>
                    </ul>
                    <ul>
                        <li>
                            <img src="/public/img/index/slider-post-black.png" alt="instagram-foto">
                        </li>
                        <li>
                            <img src="/public/img/index/slider-post-black.png" alt="instagram-foto">
                        </li>
                        <li>
                            <img src="/public/img/index/slider-post-black.png" alt="instagram-foto">
                        </li>
                    </ul>
                </div>
            </section>
        </aside>