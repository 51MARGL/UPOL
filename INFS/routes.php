<?php
function call($controller, $action)
{
    switch ($controller) {
        case 'pages':
            require_once 'admin/models/user.php';
            require_once 'admin/models/category.php';
            require_once 'admin/models/post.php';
            require_once 'admin/models/commentary.php';
            require_once 'public/controllers/' . $controller . '_controller.php';
            $controller = new PagesController();
            break;
        case 'posts':
            require_once 'admin/models/user.php';
            require_once 'admin/models/category.php';
            require_once 'admin/models/post.php';
            require_once 'admin/models/commentary.php';
            require_once 'public/controllers/' . $controller . '_controller.php';
            $controller = new PostsController();
            break;
        case 'adminPages':
            require_once 'admin/models/user.php';
            require_once 'admin/models/category.php';
            require_once 'admin/models/post.php';
            require_once 'admin/models/commentary.php';
            require_once 'admin/controllers/' . $controller . '_controller.php';
            $controller = new AdminPagesController();
            break;
        case 'user':
            require_once 'admin/models/user.php';
            require_once 'admin/models/category.php';
            require_once 'admin/models/post.php';
            require_once 'admin/models/commentary.php';
            require_once 'admin/controllers/' . $controller . '_controller.php';
            $controller = new UserController();
            break;
        case 'post':
            require_once 'admin/models/user.php';
            require_once 'admin/models/category.php';
            require_once 'admin/models/commentary.php';
            require_once 'admin/models/post.php';
            require_once 'admin/controllers/' . $controller . '_controller.php';
            $controller = new PostController();
            break;
        case 'category':
            require_once 'admin/models/user.php';
            require_once 'admin/models/post.php';
            require_once 'admin/models/commentary.php';
            require_once 'admin/models/category.php';
            require_once 'admin/controllers/' . $controller . '_controller.php';
            $controller = new CategoryController();
            break;
        case 'commentary':
            require_once 'admin/models/user.php';
            require_once 'admin/models/post.php';
            require_once 'admin/models/category.php';
            require_once 'admin/models/commentary.php';
            require_once 'admin/controllers/' . $controller . '_controller.php';
            $controller = new CommentaryController();
            break;
    }

    $controller->{$action}();
}

function redirect($controller, $method = "index", $args = array())
{
    global $core;

    $location = $core->config->base_url . "/" . $controller . "/" . $method . "/" . implode("/", $args);

    header("Location: " . $location);
    exit();
}

session_start();
$controllers = array('pages' => ['home', 'category', 'post_page', 'gallery', 'search', 'error'],
    'posts' => ['getAll', 'getById', 'getCount', 'getByCategory', 'getByCategoryDetailed'],
    'adminPages' => ['dashboard', 'post_add', 'post_edit', 'login', 'posts', 'categories', 'users', 'profile'],
    'user' => ['login', 'logout', 'add_new', 'delete', 'edit', 'autocomplete_filter'],
    'commentary' => ['add_new', 'delete'],
    'post' => ['add_new', 'delete', 'edit', 'autocomplete_filter'],
    'category' => ['add_new', 'before_delete', 'delete', 'edit', 'autocomplete_filter']);

if (array_key_exists($controller, $controllers)) {
    if (in_array($action, $controllers[$controller])) {
        call($controller, $action);
    } else {
        call('pages', 'error');
    }
} else {
    call('pages', 'error');
}
