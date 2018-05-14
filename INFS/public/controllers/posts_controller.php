<?php
class PostsController
{
    public function __construct($model)
    {
        require_once $model;
    }

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

        $posts = Post::getByCategory($_GET['category'], $_GET['count']);
        require_once 'public/views/posts/getMultiple.php';
    }

    public function getByCategoryDetailed()
    {
        if (!isset($_GET['category']) || !isset($_GET['count'])) {
            return call('pages', 'error');
        }

        $posts = Post::getByCategory($_GET['category'], $_GET['count']);
        require_once 'public/views/posts/getMultipleDetailed.php';
    }

    public function getCount()
    {        
        if (!isset($_GET['count'])) {
            return call('pages', 'error');
        }

        $posts = Post::getCount($_GET['count']);
        require_once 'public/views/posts/getMultiple.php';
    }
}
