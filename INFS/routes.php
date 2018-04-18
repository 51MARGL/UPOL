<?php
function call($controller, $action)
{    
    require_once 'controllers/' . $controller . '_controller.php';   
    
    switch ($controller) {
        case 'pages':
            $controller = new PagesController();
            break;
        case 'posts':                        
            $controller = new PostsController('models/post.php');
            break;
    }

  
    $controller->{$action}();
}

$controllers = array('pages' => ['home', 'category', 'post_page', 'gallery', 'error'],
                     'posts' => ['getAll', 'getById', 'getCount', 'getByCategory', 'getByCategoryDetailed']);


if (array_key_exists($controller, $controllers)) {
    if (in_array($action, $controllers[$controller])) {      
        call($controller, $action);        
    } else {        
        call('pages', 'error');
    }
} else {
    call('pages', 'error');
}
