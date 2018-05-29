<?php
class CategoryController
{
    public function add_new()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (unserialize($_SESSION['current_user'])->rights !== 'SA' && unserialize($_SESSION['current_user'])->rights !== 'A') {
            redirect('pages', 'error', ['Invalid Rights!']);
        }

        if (isset($_POST['name'], $_POST['parent_id'], $_POST['url_name'])) {
            $name = $_POST['name'];
            $url_name = $_POST['url_name'];
            $parent_id = $_POST['parent_id'];

            if (empty($name) || empty($parent_id) || empty($url_name)) {
                echo "{
                    \"success\": 0,
                    \"error\": {
                        \"message\": \"Error occured. Missing required fields\"
                    }
                }";
            } else {
                if (!preg_match("/^[A-Za-z0-9_-]+$/", $url_name)) {
                    echo "{
                        \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured.Url Name can contain digits, letters, underscores and dashes only.\"
                        }
                    }";
                } else {
                    if (!empty(Category::get_by_cname($name)->name)) {
                        echo "{
                            \"success\": 0,
                            \"error\": {
                                \"message\": \"Error occured. Name alreay exists.\"
                            }
                        }";
                    } else if (!empty(Category::get_by_url_name($url_name)->name)) {
                        echo "{
                            \"success\": 0,
                            \"error\": {
                                \"message\": \"Error occured. URL Name alreay exists.\"
                            }
                        }";
                    } else {
                        $parent = Category::get_by_id($parent_id);
                        if ($parent_id != '-None-' && empty($parent->name)) {
                            echo "{
                            \"success\": 0,
                            \"error\": {
                                \"message\": \"Error occured. Invalid Parent.\"
                            }
                        }";
                        } else {
                            Category::add_new($name, $url_name, $parent_id == '-None-' ? null : $parent_id);
                            echo "{
                                    \"success\": 1
                                }";
                        }
                    }
                }
            }
        } else {
            echo "{
                \"success\": 0,
                \"error\": {
                    \"message\": \"Error occured. Missing required fields\"
                }
            }";
        }
    }

    public function delete()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (isset($_GET['id'])) {
            if (unserialize($_SESSION['current_user'])->rights !== 'SA') {
                redirect('pages', 'error', ['Invalid Rights!']);
            }

            $deleted = Category::get_by_id($_GET['id']);
            foreach (Category::get_by_parent_id($deleted->id) as $category){
                Category::edit($category->id, $category->name, $category->url_name, $deleted->parent_id);
            }
            
            Category::delete($_GET['id']);
            redirect('admin', 'categories');
        }
    }

    public function before_delete()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (isset($_GET['id'])) {
            if (unserialize($_SESSION['current_user'])->rights !== 'SA') {
                redirect('pages', 'error', ['Invalid Rights!']);
            }

            $deleted = Category::get_by_id($_GET['id']);
            $message="";
            if (count(Category::get_by_parent_id($deleted->id)) > 0){
                $new_parent_name = empty(htmlspecialchars($deleted->parent_name)) ? "-None-" : htmlspecialchars($deleted->parent_name);
                $message.="Category has subcategories. After delete they will be moved to $new_parent_name.";
       
            }
            
            if (count(Post::get_by_category($deleted->id)) > 0){            
                $message.="Category has posts. After delete they will be deleted.";       
            }

            if(!empty($message)){
                echo "{
                    \"success\": 0,
                    \"error\": {
                        \"message\": \"$message\"
                    }
                }";
            }else{
                echo "{
                    \"success\": 1
                }";
            }
            
        }
    }

    public function autocomplete_filter()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }
        
        foreach (Category::all() as $category){
            $list[] = $category->name;
            $list[] = $category->parent_name;
        }
        echo json_encode(array_values(array_filter(array_unique($list))));
    }

    public function edit()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (isset($_POST['id'])) {
            if (unserialize($_SESSION['current_user'])->rights !== 'SA' && unserialize($_SESSION['current_user'])->rights !== 'A') {
                redirect('pages', 'error', ['Invalid Rights!']);
            }

            $categoryToEdit = Category::get_by_id($_POST['id']);
            if (empty($categoryToEdit)) {
                echo "{
                    \"success\": 0,
                    \"error\": {
                        \"message\": \"Error occured. Can't find Category\"
                    }
                }";
            } else {
                if (isset($_POST['name'], $_POST['parent_id'], $_POST['url_name'])) {
                    $name = $_POST['name'];
                    $url_name = $_POST['url_name'];
                    $parent_id = $_POST['parent_id'];

                    if (empty($name) || empty($parent_id) || empty($url_name)) {
                        echo "{
                            \"success\": 0,
                            \"error\": {
                                \"message\": \"Error occured. Missing required fields\"
                            }
                        }";
                    } else {
                        if (!preg_match("/^[A-Za-z0-9_-]+$/", $url_name)) {
                            echo "{
                                \"success\": 0,
                                \"error\": {
                                    \"message\": \"Error occured. URL Name can contain digits, letters underscores and dashes only.\"
                                }
                            }";
                        } else {
                            if (!empty(Category::get_by_cname($name)->name) && Category::get_by_cname($name)->name != $categoryToEdit->name) {
                                echo "{
                                    \"success\": 0,
                                    \"error\": {
                                        \"message\": \"Error occured. Name alreay exists.\"
                                    }
                                }";
                            } else if (!empty(Category::get_by_url_name($url_name)->url_name) && Category::get_by_url_name($url_name)->url_name != $categoryToEdit->url_name) {
                                echo "{
                                    \"success\": 0,
                                    \"error\": {
                                        \"message\": \"Error occured. URL Name alreay exists.\"
                                    }
                                }";
                            } else {
                                $parent = Category::get_by_id($parent_id);
                                if ($parent->name == $name) {
                                    echo "{
                                        \"success\": 0,
                                        \"error\": {
                                            \"message\": \"Error occured. Invalid Parent.\"
                                        }
                                    }";
                                } else if ($parent_id != '-None-' && empty($parent->name)) {
                                    echo "{
                                    \"success\": 0,
                                    \"error\": {
                                        \"message\": \"Error occured. Invalid Parent.\"
                                    }
                                }";
                                } else {
                                    Category::edit($categoryToEdit->id, $name, $url_name, $parent_id == '-None-' ? null : $parent_id);
                                    echo "{
                                            \"success\": 1
                                        }";
                                }
                            }
                        }
                    }
                } else {
                    echo "{
                        \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured. Missing required fields\"
                        }
                    }";
                }
            }
        } else {
            echo "{
            \"success\": 0,
            \"error\": {
                \"message\": \"Error occured. Can't find user\"
            }
        }";
        }
    }
}
