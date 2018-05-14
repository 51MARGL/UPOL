<?php
class User
{
    public $id;
    public $username;
    public $password;
    public $rights;
    public $first_name;
    public $second_name;
    public $email;
    public $profile_img;
    public $about;

    public function __construct($id, $username, $password, $rights, $first_name, $second_name, $email, $profile_img, $about)
    {
        $this->id = $id;
        $this->username = $username;
        $this->password = $password;
        $this->rights = $rights;
        $this->first_name = $first_name;
        $this->second_name = $second_name;
        $this->email = $email;
        $this->profile_img = $profile_img;
        $this->about = $about;
    }

    public static function verify($username, $password)
    {
        $db = Db::getInstance();
        $username = strval($username);
        $password = strval($password);
        $req = $db->prepare('SELECT * FROM User WHERE username = :username AND u_password = :u_password');
        $req->bindValue(':username', $username);
        $req->bindValue(':u_password', $password);
        $req->execute();
        $user = $req->fetch();
        return new User($user['id'], $user['username'],
            $user['u_password'], $user['rights'],
            $user['first_name'], $user['second_name'],
            $user['email'], $user['profile_img'],
            $user['about']);
    }

    public static function add_new($username, $email, $password, $first_name, $second_name, $profile_img, $about)
    {
        $db = Db::getInstance();
        $username = strval($username);
        $email = strval($email);
        $first_name = strval($first_name);
        $second_name = strval($second_name);
        $profile_img = strval($profile_img);
        $about = strval($about);

        $req = $db->prepare("INSERT INTO User (username, u_password, rights, first_name, second_name, email, profile_img, about)
                             VALUES (:un,:upswd,'A',:fn,:sn,:em,:pri,:ab)");
        $req->execute(array(
            ':un' => $username,
            ':upswd' => $password,
            ':fn' => $first_name,
            ':sn' => $second_name,
            ':em' => $email,
            ':pri' => $profile_img,
            ':ab' => $about
        ));
    }

    public static function get_by_userid($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('SELECT * FROM User WHERE id = :id');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
        $user = $req->fetch();
        return new User($user['id'], $user['username'],
            $user['u_password'], $user['rights'],
            $user['first_name'], $user['second_name'],
            $user['email'], $user['profile_img'],
            $user['about']);
    }

    public static function get_by_username($username)
    {
        $db = Db::getInstance();
        $username = strval($username);
        $req = $db->prepare('SELECT * FROM User WHERE username = :username');
        $req->bindValue(':username', $username);
        $req->execute();
        $user = $req->fetch();
        return new User($user['id'], $user['username'],
            $user['u_password'], $user['rights'],
            $user['first_name'], $user['second_name'],
            $user['email'], $user['profile_img'],
            $user['about']);
    }

    public static function all()
    {
        $list = [];
        $db = Db::getInstance();
        $req = $db->query('SELECT * FROM User');

        foreach ($req->fetchAll() as $user) {
            $list[] = new User($user['id'], $user['username'],
                $user['u_password'], $user['rights'],
                $user['first_name'], $user['second_name'],
                $user['email'], $user['profile_img'],
                $user['about']);
        }

        return $list;
    }

    public static function get_with_offset($count, $offset = 0)
    {
        $list = [];
        $db = Db::getInstance();
        $count = intval($count);
        $offset = intval($offset);

        $req = $db->prepare('SELECT * FROM User LIMIT :count OFFSET :offset');      
        $req->bindValue(':offset', $offset, PDO::PARAM_INT); 
        $req->bindValue(':count', $count, PDO::PARAM_INT);   
        $req->execute(); 
        foreach ($req->fetchAll() as $user) {
            $list[] = new User($user['id'], $user['username'],
                $user['u_password'], $user['rights'],
                $user['first_name'], $user['second_name'],
                $user['email'], $user['profile_img'],
                $user['about']);
        }

        return $list;
    }

    public static function delete($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('DELETE FROM User WHERE id = :id');   
        $req->bindValue(':id', $id, PDO::PARAM_INT);   
        $req->execute();
    }
}
