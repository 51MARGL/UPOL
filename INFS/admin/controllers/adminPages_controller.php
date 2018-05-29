<?php
class AdminPagesController
{
    public function dashboard()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        $posts = Post::all();
        $targetpage = "/admin/dashboard";
        $total = count($posts);
        $adjacents = 1;
        $limit = 5; //how many items to show per page
        $pageNum = $_GET['page'] ?? 0;

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

        $page = "dashboard.php";
        require_once 'admin/views/layout.php';
    }

    public function post_add()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        $page = "post_add.php";
        require_once 'admin/views/layout.php';
    }

    public function post_edit()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (!isset($_GET['id'])) {
            redirect('admin', 'posts');
        }
        $post_to_edit = Post::get_by_id($_GET['id']);
        $id = $post_to_edit->id;
        $category_id = htmlspecialchars($post_to_edit->category->id);
        $heading = htmlspecialchars($post_to_edit->heading);
        $description = htmlspecialchars($post_to_edit->description);
        $text = htmlspecialchars($post_to_edit->text);
        $tags = htmlspecialchars($post_to_edit->tags);
        $url_name = htmlspecialchars($post_to_edit->url_name);

        $title = htmlspecialchars($post_to_edit->heading);

        $page = "post_edit.php";
        require_once 'admin/views/layout.php';
    }

    public function login()
    {
        if (isset($_SESSION['logged_in'])) {
            redirect('admin', 'dashboard');
        }

        if (isset($_GET['error'])) {
            $error = $_GET['error'];
            if (isset($_GET['username'])) {
                $username = $_GET['username'];
            }
        }
        $page = "login.php";
        require_once 'admin/views/layout.php';

    }

    public function categories()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (isset($_GET['filter'])) {
            $categories = Category::filter($_GET['filter']);
            $targetpage = "/admin/categories/filter=" . $_GET['filter'];
        } else {
            $categories = Category::all();
            $targetpage = "/admin/categories";
        }

        $total = count($categories);
        $adjacents = 1;
        $limit = 5; //how many items to show per page
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
        $categoriesToDisplay = array_slice($categories, $start, $limit);
        $curnm = count($categoriesToDisplay);

        $page = "categories.php";
        require_once 'admin/views/layout.php';
    }

    public function posts()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (isset($_GET['filter'])) {
            $posts = Post::filter($_GET['filter']);
            $targetpage = "/admin/posts/filter=" . $_GET['filter'];
        } else {
            $posts = Post::all();
            $targetpage = "/admin/posts";
        }

        $total = count($posts);
        $adjacents = 1;
        $limit = 5; //how many items to show per page
        $pageNum = $_GET['page'] ?? 0;

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

        $page = "posts.php";
        require_once 'admin/views/layout.php';
    }
    public function profile()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (isset($_GET['userid'])) {
            $user_for_profile = User::get_by_userid($_GET['userid']);
            if (empty($user_for_profile->username)) {
                redirect('pages', 'error', ['User not found']);
            }
            $page = "profile.php";
            require_once 'admin/views/layout.php';
        } else {
            redirect('pages', 'error', ['User not found']);
        }
    }
    public function users()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (isset($_GET['filter'])) {
            $users = User::filter($_GET['filter']);
            $targetpage = "/admin/users/filter=" . $_GET['filter'];
        } else {
            $users = User::all();
            $targetpage = "/admin/users";
        }

        $total = count($users);
        $adjacents = 1;        
        $limit = 5; //how many items to show per page
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
        $usersToDisplay = array_slice($users, $start, $limit);
        $curnm = count($usersToDisplay);

        $page = "users.php";
        require_once 'admin/views/layout.php';
    }
}
