<?php
class Commentary
{
    public $id;
    public $post;
    public $reply_id;
    public $text;
    public $u_name;
    public $email;
    public $author;
    public $time;

    public function __construct($id, $post, $reply_id, $text, $u_name, $email, $author, $time)
    {
        $this->id = $id;
        $this->post = $post;
        $this->reply_id = $reply_id;
        $this->text = $text;
        $this->u_name = $u_name;
        $this->email = $email;
        $this->author = $author;
        $this->time = $time;
    }

    public static function add_new($post_id, $reply_id, $text, $u_name, $email, $author_id)
    {
        $db = Db::getInstance();
        $post_id = intval($post_id);
        $reply_id = intval($reply_id) == 0 ? null : intval($reply_id);
        $text = strval($text);
        $u_name = strval($u_name);
        $email = strval($email);
        $author_id = intval($author_id) == 0 ? null : intval($author_id);
        $time = date('Y-m-d H:i:s');

        $req = $db->prepare("INSERT INTO Commentary (post_id, reply_id, c_text, u_name, email, `user_id`, `time`)
                             VALUES (:post_id, :reply_id, :c_text, :u_name,:email,:usid,:tme)");
        $req->execute(array(
            ':post_id' => $post_id,
            ':reply_id' => $reply_id,
            ':c_text' => $text,
            ':u_name' => $u_name,
            ':email' => $email,
            ':usid' => $author_id,
            ':tme' => $time
        ));
    }

    public static function get_by_id($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('SELECT * FROM Commentary WHERE id = :id');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
        $comment = $req->fetch();
        return new Commentary($comment['id'], Post::get_by_id($comment['post_id']),
            $comment['reply_id'], $comment['c_text'],
            $comment['u_name'], $comment['email'],
            User::get_by_userid($comment['user_id']), $comment['time']);
    }

    public static function get_by_reply_id($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('SELECT * FROM Commentary WHERE reply_id = :id ORDER BY `time` desc');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
        foreach ($req->fetchAll() as $comment) {
            $list[] = new Commentary($comment['id'], Post::get_by_id($comment['post_id']),
            $comment['reply_id'], $comment['c_text'],
            $comment['u_name'], $comment['email'],
            User::get_by_userid($comment['user_id']), $comment['time']);
        }

        return $list;
    }

    public static function get_by_post_id($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('SELECT * FROM Commentary WHERE post_id = :id ORDER BY `time` desc');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
        foreach ($req->fetchAll() as $comment) {
            $list[] = new Commentary($comment['id'], Post::get_by_id($comment['post_id']),
            $comment['reply_id'], $comment['c_text'],
            $comment['u_name'], $comment['email'],
            User::get_by_userid($comment['user_id']), $comment['time']);
        }

        return $list;
    }

    public static function all()
    {
        $list = [];
        $db = Db::getInstance();
        $req = $db->query('SELECT * FROM Commentary ORDER BY `time` desc');

        foreach ($req->fetchAll() as $comment) {
            $list[] = new Commentary($comment['id'], Post::get_by_id($comment['post_id']),
            $comment['reply_id'], $comment['c_text'],
            $comment['u_name'], $comment['email'],
            User::get_by_userid($comment['user_id']), $comment['time']);
        }

        return $list;
    }    

    public static function delete($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('DELETE FROM Commentary WHERE id = :id');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
    }
}
