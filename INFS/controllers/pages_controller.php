<?php
class PagesController
{
    public function home()
    {
        require_once 'views/pages/home.php';
    }

    public function category()
    {
        require_once 'views/pages/category.php';
    }
    
    public function post_page()
    {
        require_once 'views/pages/post_page.php';
    }

    public function gallery()
    {
        require_once 'views/pages/gallery.php';
    }
    
    public function error()
    {
        require_once 'views/pages/error.php';
    }
}
