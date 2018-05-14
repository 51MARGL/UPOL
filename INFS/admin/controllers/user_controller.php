<?php
class UserController
{
    public function login()
    {
        if (isset($_POST['username'], $_POST['password'])) {
            $username = $_POST['username'];
            $password = hash('sha256', $_POST['password']);

            if (empty($username) or empty($password)) {
                if (!empty($username)) {
                    redirect('admin', 'login', ['All fields are required!', $username]);
                } else {
                    redirect('admin', 'login', ['All fields are required!']);
                }
            } else {
                $user = User::verify($username, $password);
                if (!empty($user->username)) {
                    $_SESSION['logged_in'] = true;
                    $_SESSION['current_user'] = serialize($user);
                    redirect('admin', 'dashboard');
                } else {
                    if (!empty($username)) {
                        redirect('admin', 'login', ['Incorect credentials!', $username]);
                    } else {
                        redirect('admin', 'login', ['Incorect credentials!']);
                    }
                }
            }
        } else {
            redirect('admin', 'login', ['All fields are required!']);
        }
    }

    public function logout()
    {
        unset($_SESSION["logged_in"]);
        unset($_SESSION["current_user"]);
        redirect('admin', 'login');
    }

    public function add_new()
    {
        if (!isset($_SESSION['logged_in'])) {
            redirect('admin', 'login');
        }

        if (unserialize($_SESSION['current_user'])->rights !== 'SA') {
            redirect('pages', 'error', ['Invalid Rights!']);
        }

        if (isset($_POST['username'], $_POST['email'], $_POST['pswd'], $_POST['pswd_conf'], $_POST['first_name'], $_POST['second_name'])) {
            $username = $_POST['username'];
            $email = $_POST['email'];
            $password = hash('sha256', $_POST['pswd']);
            $password_cnf = hash('sha256', $_POST['pswd_conf']);
            $first_name = $_POST['first_name'];
            $second_name = $_POST['second_name'];
            $about = $_POST['editor1'];

            if (empty($username) or empty($email) or empty($password) or empty($password_cnf) or empty($first_name) or empty($second_name)) {
                echo "{
                    \"success\": 0,
                    \"error\": {
                        \"message\": \"Error occured. Missing required fields\"
                    }
                }";
            } else {
                if (!preg_match("/^[A-Za-z0-9]+$/", $username)) {
                    echo "{
                        \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured. Username can contain digits and letters only.\"
                        }
                    }";
                } else {
                    if (!empty(User::get_by_username($username)->username)) {
                        echo "{
                        \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured. Username alreay exists.\"
                        }
                    }";
                    } else {
                        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                            echo "{
                            \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured. Invalid email format.\"
                        }
                    }";
                        } else {
                            if ($password !== $password_cnf) {
                                echo "{
                            \"success\": 0,
                        \"error\": {
                            \"message\": \"Error occured. Passwords don't match.\"
                        }
                    }";
                            } else {
                                if (isset($_FILES['profileimage']) && $_FILES['profileimage']['error'] == 0) {
                                    require_once 'uploader/upload.php';
                                    $target_dir = "/uploader/files/";
                                    $file_name = basename($_FILES["profileimage"]["name"]);
                                    $imageFileType = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
                                    $result = json_decode(upload_file($target_dir, $file_name, $imageFileType, $_FILES["profileimage"]["tmp_name"]), true);

                                    if ($result['uploaded'] == 0) {
                                        $message = $result['error']['message'];
                                        echo "{
                                \"success\": 0,
                                \"error\": {
                                    \"message\": \"$message\"
                                }
                            }";
                                    } else {
                                        $profile_img = $result['url'];
                                        User::add_new($username, $email, $password, $first_name, $second_name, $profile_img, $about);
                                        echo "{
                                    \"success\": 1
                                }";
                                    }
                                } else {
                                    $profile_img = '/uploader/files/profiledefault.png';
                                    User::add_new($username, $email, $password, $first_name, $second_name, $profile_img, $about);
                                    echo "{
                                \"success\": 1
                            }";
                                }
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
            if (unserialize($_SESSION['current_user'])->rights !== 'SA'
                && unserialize($_SESSION['current_user'])->id !== $_GET['id']) {
                redirect('pages', 'error', ['Invalid Rights!']);
            }

            $deleted = User::get_by_userid($_GET['id']);
            User::delete($_GET['id']);
            if (file_exists(ROOTPATH . $deleted->profile_img)) {
                unlink($file);
            }
            redirect('admin', 'users');
        }
    }
}
