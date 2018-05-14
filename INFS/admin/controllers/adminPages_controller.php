<?php
class AdminPagesController
{
    public function dashboard()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        $page = "dashboard.php";
        require_once 'admin/views/layout.php';
    }

    public function edit()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        $page = "edit.php";
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

        $page = "categories.php";
        require_once 'admin/views/layout.php';
    }

    public function posts()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        $page = "posts.php";
        require_once 'admin/views/layout.php';
    }
    public function profile()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if(isset($_GET['userid'])){
            $user_for_profile = User::get_by_userid($_GET['userid']);
            if (empty($user_for_profile->username)){
                redirect('pages', 'error', ['User not found']);
            }
            $page = "profile.php";
            require_once 'admin/views/layout.php';
        }
        else{
            redirect('pages', 'error', ['User not found']);
        }
    }
    public function users()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        $users = User::all();

        $total = count($users);
        $adjacents = 3;
        $targetpage = "/admin/users"; //your file name
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
        $usersToDisplay = User::get_with_offset($limit, $start);
        $curnm = count($usersToDisplay);
        $page = "users.php";
        require_once 'admin/views/layout.php';
    }
}
