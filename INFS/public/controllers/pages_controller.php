<?php
class PagesController
{
    public function home()
    {
        $most_viewed = array_slice(Post::get_by_views(),0,3);
        $page = "home.php";
        require_once 'public/views/layout.php';
    }

    public function category()
    {
        if (isset($_GET['location'])) {
            $location = $_GET['location'];
        } else {
            $location = 'Latest Articles';
        }

        if (isset($_GET['filter'])) {
            $posts = Post::filter($_GET['filter']);
            $targetpage = "/home/categories/filter=" . $_GET['filter'];
        } else if (isset($_GET['author'])) {
            $author = User::get_by_userid($_GET['author']);
            $posts = Post::get_by_author($author->id);
            $targetpage = "/home/posts/by=" . $_GET['author'] . "/";
            $location = "by " . $author->first_name . " " . $author->second_name;
        } else {
            $posts = Post::get_by_category(Category::get_by_url_name($location)->id);
            $targetpage = "/home/categories/$location";
            $location = Category::get_by_url_name($location)->name;
        }

        $most_viewed = array_slice(Post::get_by_views(),0,5);
        $most_hot = array_slice(Post::get_hot(),0,3);
        $total = count($posts);
        $adjacents = 2;
        $limit = 10; //how many items to show per page
        $pageNum = $_GET['page'];

        if ($pageNum) {
            $start = ($pageNum - 1) * $limit; //first item to display on this page
        } else {
            $start = 0;
        }

        /* Setup page vars for display. */
        if ($pageNum == 0) {
            $pageNum = 1;
        }
        //if no page var is given, default to 1.
        $prev = $pageNum - 1; //previous page is current page - 1
        $next = $pageNum + 1; //next page is current page + 1
        $lastpage = ceil($total / $limit); //lastpage.
        $lpm1 = $lastpage - 1; //last page minus 1
        $postsToDisplay = array_slice($posts, $start, $limit);
        $curnm = count($postsToDisplay);

        $page = "category.php";
        require_once 'public/views/layout.php';
    }

    public function search()
    {
        $location = 'Search';
        if (isset($_GET['filter'])) {
            $posts = Post::filter($_GET['filter']);
            $targetpage = "/home/posts/search/filter=" . $_GET['filter'];
        }

        $most_viewed = array_slice(Post::get_by_views(),0,5);
        $most_hot = array_slice(Post::get_hot(),0,3);

        $total = count($posts);
        $adjacents = 2;
        $limit = 10; //how many items to show per page
        $pageNum = $_GET['page'];

        if ($pageNum) {
            $start = ($pageNum - 1) * $limit; //first item to display on this page
        } else {
            $start = 0;
        }

        /* Setup page vars for display. */
        if ($pageNum == 0) {
            $pageNum = 1;
        }
        //if no page var is given, default to 1.
        $prev = $pageNum - 1; //previous page is current page - 1
        $next = $pageNum + 1; //next page is current page + 1
        $lastpage = ceil($total / $limit); //lastpage.
        $lpm1 = $lastpage - 1; //last page minus 1
        $postsToDisplay = array_slice($posts, $start, $limit);
        $curnm = count($postsToDisplay);

        $page = "search_page.php";
        require_once 'public/views/layout.php';
    }

    public function post_page()
    {
        if (isset($_GET['post'])) {
            $post_url = $_GET['post'];
        } else {
            redirect('pages', 'error', ['Post Not Found']);
        }

        $post = Post::get_by_url_name($post_url);
        Post::add_view($post->id);

        $most_viewed = array_slice(Post::get_by_views(),0,5);
        $most_hot = array_slice(Post::get_hot(),0,3);

        $all_posts = array_values(Post::get_by_author($post->author->id));
        $index = array_search($post, $all_posts);
        $prev_post = $all_posts[$index - 1] ?? end($all_posts);
        $next_post = $all_posts[$index + 1] ?? $all_posts[0];
        $related_posts = array_slice(Post::get_by_category($post->category->id), 0, 2);
        $related_posts = array_values(count($related_posts) > 1 ? $related_posts : array_slice(Post::all(), 0, 2));
        $location = $post->category->name . " / " . $post->heading;
        $location_post = "Post Page";

        require_once "public/views/comments/commentaries.php";

        $root_comments = array_filter(Commentary::get_by_post_id($post->id), function($com) {
            return empty($com->reply_id); 
        });

        $page = "post_page.php";
        require_once 'public/views/layout.php';
    }

    public function gallery()
    {
        $location = "Gallery";
        $page = "gallery.php";
        require_once 'public/views/layout.php';
    }

    public function error()
    {
        if (isset($_GET['error'])) {
            $error_msg = $_GET['error'];
        }
        $page = "error.php";
        require_once 'public/views/layout.php';
    }
}
