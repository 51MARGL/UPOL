<?php
function call($controller, $action)
{
    switch ($controller) {
        case 'pages':
            require_once 'public/controllers/' . $controller . '_controller.php';
            $controller = new PagesController();
            break;
        case 'posts':
            require_once 'public/controllers/' . $controller . '_controller.php';
            $controller = new PostsController('public/models/post.php');
            break;
        case 'adminPages':
            require_once 'admin/models/user.php';
            require_once 'admin/controllers/' . $controller . '_controller.php';
            $controller = new AdminPagesController();
            break;
        case 'user':
            require_once 'admin/models/user.php';
            require_once 'admin/controllers/' . $controller . '_controller.php';
            $controller = new UserController();
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
$controllers = array('pages' => ['home', 'category', 'post_page', 'gallery', 'error'],
                     'posts' => ['getAll', 'getById', 'getCount', 'getByCategory', 'getByCategoryDetailed'],
                     'adminPages' => ['dashboard', 'edit', 'login', 'posts', 'categories', 'users', 'profile'],
                     'user' => ['login', 'logout', 'add_new', 'delete']);

if (array_key_exists($controller, $controllers)) {
    if (in_array($action, $controllers[$controller])) {
        call($controller, $action);
    } else {
        call('pages', 'error');
    }
} else {
    call('pages', 'error');
}
