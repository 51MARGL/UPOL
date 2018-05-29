<?php
class PostController
{
    public function add_new()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (unserialize($_SESSION['current_user'])->rights !== 'SA' && unserialize($_SESSION['current_user'])->rights !== 'A') {
            redirect('pages', 'error', ['Invalid Rights!']);
        }

        if (isset($_POST['title'], $_POST['category_id'], $_POST['description'], $_POST['editor1'], $_POST['url_name'])) {
            $heading = $_POST['title'];
            $url_name = $_POST['url_name'];
            $category_id = $_POST['category_id'];
            $description = $_POST['description'];
            $text = $_POST['editor1'];
            $tags = $_POST['tags'];

            if (empty($heading) || empty($url_name) || empty($category_id)
                || empty($description) || empty($text)) {
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
                    if (!empty(Post::get_by_url_name($url_name)->heading)) {
                        echo "{
                            \"success\": 0,
                            \"error\": {
                                \"message\": \"Error occured. URL Name alreay exists.\"
                            }
                        }";
                    } else {
                        $category = Category::get_by_id($category_id);
                        if (empty($category->name)) {
                            echo "{
                            \"success\": 0,
                            \"error\": {
                                \"message\": \"Error occured. Invalid Category.\"
                            }
                        }";
                        } else {
                            if (isset($_FILES['post_image']) && $_FILES['post_image']['error'] == 0) {
                                require_once 'uploader/upload.php';
                                $target_dir = "/uploader/files/";
                                $file_name = basename($_FILES["post_image"]["name"]);
                                $imageFileType = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
                                $result = json_decode(upload_file($target_dir, $file_name, $imageFileType, $_FILES["post_image"]["tmp_name"]), true);

                                if ($result['uploaded'] == 0) {
                                    $message = $result['error']['message'];
                                    echo "{
                                                \"success\": 0,
                                                \"error\": {
                                                    \"message\": \"$message\"
                                                }
                                            }";
                                } else {
                                    $post_img = $result['url'];
                                    Post::add_new($heading, $category_id, $post_img, $description, $text,
                                        $tags, unserialize($_SESSION['current_user'])->id, $url_name);
                                    echo "{
                                \"success\": 1
                            }";
                                }
                            } else {
                                Post::add_new($heading, $category_id, null, $description, $text,
                                    $tags, unserialize($_SESSION['current_user'])->id, $url_name);
                                echo "{
                                        \"success\": 1
                                    }";
                            }
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
            if (unserialize($_SESSION['current_user'])->rights !== 'SA' && unserialize($_SESSION['current_user'])->rights !== 'A') {
                redirect('pages', 'error', ['Invalid Rights!']);
            }

            $deleted = Post::get_by_id($_GET['id']);

            if (unserialize($_SESSION['current_user'])->id !== $deleted->author->id && unserialize($_SESSION['current_user'])->rights !== 'SA') {
                redirect('pages', 'error', ['Invalid Rights!']);
            }

            Post::delete($_GET['id']);
            redirect('admin', 'posts');
        }
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

            $postToEdit = Post::get_by_id($_POST['id']);
            if (empty($postToEdit)) {
                echo "{
                    \"success\": 0,
                    \"error\": {
                        \"message\": \"Error occured. Can't find Category\"
                    }
                }";
            } else {
                if (isset($_POST['title'], $_POST['category_id'], $_POST['description'], $_POST['editor1'], $_POST['url_name'])) {
                    $heading = $_POST['title'];
                    $url_name = $_POST['url_name'];
                    $category_id = $_POST['category_id'];
                    $description = $_POST['description'];
                    $text = $_POST['editor1'];
                    $tags = $_POST['tags'];
                    $id = $_POST['id'];

                    if (empty($heading) || empty($url_name) || empty($category_id)
                        || empty($description) || empty($text)) {
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
                            if (!empty(Post::get_by_url_name($url_name)->name) && Post::get_by_url_name($url_name)->url_name != $postToEdit->url_name) {
                                echo "{
                                    \"success\": 0,
                                    \"error\": {
                                        \"message\": \"Error occured. URL Name alreay exists.\"
                                    }
                                }";
                            } else {
                                $category = Category::get_by_id($category_id);
                                if (empty($category->name)) {
                                    echo "{
                                    \"success\": 0,
                                    \"error\": {
                                        \"message\": \"Error occured. Invalid Category.\"
                                    }
                                }";
                                } else {
                                    if (isset($_FILES['post_image']) && $_FILES['post_image']['error'] == 0) {
                                        require_once 'uploader/upload.php';
                                        $target_dir = "/uploader/files/";
                                        $file_name = basename($_FILES["post_image"]["name"]);
                                        $imageFileType = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
                                        $result = json_decode(upload_file($target_dir, $file_name, $imageFileType, $_FILES["post_image"]["tmp_name"]), true);

                                        if ($result['uploaded'] == 0) {
                                            $message = $result['error']['message'];
                                            echo "{
                                                        \"success\": 0,
                                                        \"error\": {
                                                            \"message\": \"$message\"
                                                        }
                                                    }";
                                        } else {
                                            $post_img = $result['url'];
                                            Post::edit($id, $heading, $category_id, $post_img, $description, $text,
                                                $tags, $url_name);
                                            echo "{
                                                        \"success\": 1
                                                    }";
                                        }
                                    } else {
                                        Post::edit($id, $heading, $category_id, null, $description, $text,
                                            $tags, $url_name);
                                        echo "{
                                                \"success\": 1
                                            }";
                                    }
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
                \"message\": \"Error occured. Can't find user1\"
            }
        }";
        }
    }

    public function autocomplete_filter()
    {
        foreach (Post::all() as $post){
            $list[] = $post->heading;
            $list[] = $post->category->name;
            $list[] = $post->author->first_name . " " . $post->author->second_name;
            $list[] = (new DateTime($post->time))->format('F d, Y');
            foreach(preg_split('/(?<=[.?!\n])\s*(?=[a-z])/i', strip_tags($post->text)) as $sentence){
                $list[] = trim(preg_replace('/&(\S)+;/', '', substr($sentence,0,40)));            
            }
            foreach(explode(',', $post->tags) as $tag){
                $list[] = $tag;            
            }
        }
        echo json_encode(array_values(array_filter(array_unique($list))));
    }
}
