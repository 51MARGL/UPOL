<?php
class CommentaryController
{
    public function add_new()
    {
        if (isset($_POST['post_id'], $_POST['text'])) {
            $post_id = $_POST['post_id'];
            $text = $_POST['text'];
            $reply_id = $_POST['reply_id'];
            $name = $_POST['name'];
            $email = $_POST['email'];
            $user_id = $_POST['user_id'];

            if ((empty($post_id) or empty($text)) or ((empty($name) or empty($email)) && empty($user_id))) {
                echo "{
                    \"success\": 0,
                    \"error\": {
                        \"message\": \"Error occured. Missing required fields\"
                    }
                }";
            } else {
                if (!empty($name) && !preg_match("/^[A-Za-z0-9\s]+$/", $name)) {
                    echo "{
                        \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured. Name can contain digits,letters and spaces only.\"
                        }
                    }";
                } else {

                    if (!empty($email) && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
                        echo "{
                            \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured. Invalid email format.\"
                        }
                    }";
                    } else {
                        Commentary::add_new($post_id, $reply_id, $text, $name, $email, $user_id);
                        echo "{
                                    \"success\": 1
                                }";
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

            $deleted = Commentary::get_by_id($_GET['id']);

            if ((unserialize($_SESSION['current_user'])->id !== $deleted->author->id && unserialize($_SESSION['current_user'])->id !== $deleted->post->author->id) && unserialize($_SESSION['current_user'])->rights !== 'SA') {
                redirect('pages', 'error', ['Invalid Rights!']);
            }

            Commentary::delete($_GET['id']);            
        }
    }
}
