<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="/admin/css/autocomplete.css" rel="stylesheet">
<header>
    <div class="top-nav-bar">
        <div class="logo">
            <a href="/home/">
                <h1>
                    <span class="logo-express black">Express</span>
                    <span class="logo-blog kinda-blue">Blogs & Magazines</span>
                </h1>
            </a>
        </div>
        <nav class="menu grey">
            <ul>
                <li class="not-selected-button">
                    <a href="/home/">Home</a>
                </li>
                <li class="not-selected-button">
                    <a href="/home/categories/world/">World</a>
                    <div>
                        <div class="submenu-space"></div>
                        <ul>
                            <?php foreach (Category::get_by_parent_id(Category::get_by_url_name("world")->id) as $category) {?>
                                <li class="dir">
                                    <a href="/home/categories/<?php echo htmlspecialchars($category->url_name) ?>"><?php echo htmlspecialchars($category->name) ?></a>
                                 </li>
                            <?php }?>
                        </ul>
                    </div>
                </li>
                <li class="not-selected-button">
                    <a href="/home/categories/sports/">Sport</a>
                    <div>
                        <div class="submenu-space"></div>
                        <ul>
                            <?php foreach (Category::get_by_parent_id(Category::get_by_url_name("sports")->id) as $category) {?>
                                    <li class="dir">
                                        <a href="/home/categories/<?php echo htmlspecialchars($category->url_name) ?>"><?php echo htmlspecialchars($category->name) ?></a>
                                    </li>
                            <?php }?>
                        </ul>
                    </div>
                </li>
                <li class="not-selected-button">
                    <a href="/home/categories/lifestyle/">Lifestyle</a>
                    <div>
                        <div class="submenu-space"></div>
                        <ul>
                            <?php foreach (Category::get_by_parent_id(Category::get_by_url_name("lifestyle")->id) as $category) {?>
                                    <li class="dir">
                                        <a href="/home/categories/<?php echo htmlspecialchars($category->url_name) ?>"><?php echo htmlspecialchars($category->name) ?></a>
                                    </li>
                            <?php }?>
                        </ul>
                    </div>
                </li>
                <li class="not-selected-button">
                    <a href="/home/categories/technology/">Technology</a>
                    <div>
                        <div class="submenu-space"></div>
                        <ul>
                            <?php foreach (Category::get_by_parent_id(Category::get_by_url_name("technology")->id) as $category) {?>
                                    <li class="dir">
                                        <a href="/home/categories/<?php echo htmlspecialchars($category->url_name) ?>"><?php echo htmlspecialchars($category->name) ?></a>
                                    </li>
                            <?php }?>
                        </ul>
                    </div>
                </li>
                <li class="not-selected-button">
                    <a href="/home/categories/food-health/">Food &amp; Health</a>
                    <div>
                        <div class="submenu-space"></div>
                        <ul>
                            <?php foreach (Category::get_by_parent_id(Category::get_by_url_name("technology")->id) as $category) {?>
                                    <li class="dir">
                                        <a href="/home/categories/<?php echo htmlspecialchars($category->url_name) ?>"><?php echo htmlspecialchars($category->name) ?></a>
                                    </li>
                            <?php }?>
                        </ul>
                    </div>
                </li>
                <li>
                    <a class="btn-login" href="/admin/login/"><i class="material-icons">exit_to_app</i></a>
                    <a class="btn-search" href="/home/posts/search/"><i class="material-icons">search</i></a>            
                </li>
            </ul>
        </nav>
    </div>
</header>
<section class="location-container grey">
    <div class="location">
        <?php if ($location == "Search"){?>
        <form class="search-form" action="/home/posts/search/" method="post" autocomplete="off">
            <div class="autocomplete">
                <input name="filter" type="text"  value="<?php echo htmlspecialchars($_GET['filter'] ?? "");?>" placeholder="Search Posts...">
                <button type="submit">Search</button>
            </div>
        </form>
        <?php } else if (!empty($location_post)){ ?>
            <h2><?php echo htmlspecialchars($location_post) ?></h2>
        <?php }else { ?>
            <h2><?php echo htmlspecialchars($location) ?></h2>
        <?php }?>
        <h3>Home / <?php echo htmlspecialchars($location) ?></h3>
    </div>
</section>