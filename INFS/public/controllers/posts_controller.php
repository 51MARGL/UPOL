<?php
class PostsController
{
    public function getAll()
    {
        $posts = Post::all();
        require_once 'public/views/posts/getMultiple.php';
    }

    public function getById()
    {
        if (!isset($_GET['id'])) {
            return call('pages', 'error');
        }

        $post = Post::find($_GET['id']);
        require_once 'public/views/posts/getSingle.php';
    }

    public function getByCategory()
    {
        if (!isset($_GET['category']) || !isset($_GET['count'])) {
            return call('pages', 'error');
        }

        if (isset($_GET['offset'])) {
            $offset = $_GET['offset'];
        } else {
            $offset = 0;
        }

        if (is_int($_GET['category'])) {
            $category = $_GET['category'];
        } else {
            $category = Category::get_by_url_name($_GET['category'])->id;
        }
        $posts = array_slice(Post::get_by_category($category), $offset, $_GET['count']);
        require_once 'public/views/posts/getMultiple.php';
    }

    public function getByCategoryDetailed()
    {
        if (!isset($_GET['category']) || !isset($_GET['count'])) {
            return call('pages', 'error');
        }

        if (isset($_GET['offset'])) {
            $offset = $_GET['offset'];
        } else {
            $offset = 0;
        }

        if (is_int($_GET['category'])) {
            $category = $_GET['category'];
        } else {
            $category = Category::get_by_url_name($_GET['category'])->id;
        }
        
        $posts = array_slice(Post::get_by_category($category), $offset, $_GET['count']);
        require_once 'public/views/posts/getMultipleDetailed.php';
    }

    public function getCount()
    {
        if (!isset($_GET['count'])) {
            return call('pages', 'error');
        }

        $posts = Post::get_with_offset($_GET['count']);
        require_once 'public/views/posts/getMultiple.php';
    }
}
