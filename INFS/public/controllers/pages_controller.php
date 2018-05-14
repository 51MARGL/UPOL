<?php
class PagesController
{
    public function home()
    {        
        $page = "home.php";
        require_once 'public/views/layout.php';        
    }

    public function category()
    {
        if (isset($_GET ['location'])) {
            $location = str_replace("And", " & ", $_GET['location']);     

        } else {
             $location = 'Latest Articles';
        }
        $page = "category.php";
        require_once 'public/views/layout.php';
    }
    
    public function post_page()
    {
        $page = "post_page.php";
        require_once 'public/views/layout.php';
    }

    public function gallery()
    {
        $page = "gallery.php";
        require_once 'public/views/layout.php';
    }
    
    public function error()
    {
        if (isset($_GET['error'])){
            $error_msg = $_GET['error'];
        }
        $page = "error.php";
        require_once 'public/views/layout.php';
    }
}
