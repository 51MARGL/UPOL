<?php
class Post
{
    public $id;
    public $category;
    public $imgsrc;
    public $heading;
    public $description;
    public $text;
    public $tags;
    public $time;
    public $author;
    public $url_name;

    public function __construct($id, $category, $imgsrc, $heading, $description, $text, $tags, $time, $author, $url_name)
    {
        $this->id = $id;
        $this->category = $category;
        $this->imgsrc = $imgsrc;
        $this->heading = $heading;
        $this->description = $description;
        $this->text = $text;
        $this->tags = $tags;
        $this->time = $time;
        $this->author = $author;
        $this->url_name = $url_name;
    }

    public static function all()
    {
        $list = [];
        $db = Db::getInstance();
        $req = $db->query('SELECT * FROM Post ORDER BY `time` desc');

        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], Category::get_by_id($post['category_id']),
                $post['imgsrc'], $post['heading'], $post['description'],
                $post['text'], $post['tags'], $post['time'],
                User::get_by_userid($post['author_id']), $post['url_name']);
        }

        return $list;
    }

    public static function add_new($heading, $category_id, $imgsrc, $description, $text, $tags, $author_id, $url_name)
    {
        $db = Db::getInstance();
        $heading = strval($heading);
        $category_id = intval($category_id);
        $imgsrc = strval($imgsrc);
        $description = strval($description);
        $text = strval($text);
        $tags = strval($tags);
        $time = date('Y-m-d H:i:s');
        $author_id = intval($author_id);
        $url_name = strval($url_name);
        $req = $db->prepare("INSERT INTO Post (category_id, imgsrc, heading, `description`, `text`, tags, `time`, author_id, url_name)
                             VALUES (:cid, :img, :head, :descr, :txt, :tags, :tm, :aid, :unm)");
        $req->execute(array(
            ':cid' => $category_id,
            ':img' => $imgsrc,
            ':head' => $heading,
            ':descr' => $description,
            ':txt' => $text,
            ':tags' => $tags,
            ':tm' => $time,
            ':aid' => $author_id,
            ':unm' => $url_name
        ));
    }

    public static function edit($id, $heading, $category_id, $imgsrc, $description, $text, $tags, $url_name)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $heading = strval($heading);
        $category_id = intval($category_id);
        $imgsrc = strval($imgsrc);
        $description = strval($description);
        $text = strval($text);
        $tags = strval($tags);
        $url_name = strval($url_name);
        $req = $db->prepare("UPDATE Post SET category_id = :cid, imgsrc = :img, heading = :head, `description` = :descr, `text` = :txt, tags = :tags, url_name = :unm
                             WHERE id = :id");
        $req->execute(array(
            ':cid' => $category_id,
            ':img' => $imgsrc,
            ':head' => $heading,
            ':descr' => $description,
            ':txt' => $text,
            ':tags' => $tags,
            ':unm' => $url_name,
            ':id' => $id
        ));
    }

    public static function delete($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('DELETE FROM Post WHERE id = :id');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
    }

    public static function get_by_id($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('SELECT * FROM Post WHERE id = :id ORDER BY `time` desc');
        $req->execute(array('id' => $id));
        $post = $req->fetch();
        return new Post($post['id'], Category::get_by_id($post['category_id']),
            $post['imgsrc'], $post['heading'], $post['description'],
            $post['text'], $post['tags'], $post['time'],
            User::get_by_userid($post['author_id']), $post['url_name']);
    }

    public static function get_by_url_name($url_name)
    {
        $db = Db::getInstance();
        $id = strval($url_name);
        $req = $db->prepare('SELECT * FROM Post WHERE url_name = :url_name ORDER BY `time` desc');
        $req->execute(array('url_name' => $url_name));
        $post = $req->fetch();
        return new Post($post['id'], Category::get_by_id($post['category_id']),
            $post['imgsrc'], $post['heading'], $post['description'],
            $post['text'], $post['tags'], $post['time'],
            User::get_by_userid($post['author_id']), $post['url_name']);
    }

    public static function get_by_category($category)
    {
        $db = Db::getInstance();
        $category = intval($category);
        $req = $db->prepare('SELECT * FROM Post WHERE category_id = :category ORDER BY `time` desc');
        $req->bindValue(':category', $category, PDO::PARAM_INT);
        $req->execute();
        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], Category::get_by_id($post['category_id']),
                $post['imgsrc'], $post['heading'], $post['description'],
                $post['text'], $post['tags'], $post['time'],
                User::get_by_userid($post['author_id']), $post['url_name']);
        }

        return $list;
    }

    public static function get_by_author($author)
    {
        $db = Db::getInstance();
        $author = intval($author);
        $req = $db->prepare('SELECT * FROM Post WHERE author_id = :author ORDER BY `time` desc');
        $req->bindValue(':author', $author, PDO::PARAM_INT);
        $req->execute();
        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], Category::get_by_id($post['category_id']),
                $post['imgsrc'], $post['heading'], $post['description'],
                $post['text'], $post['tags'], $post['time'],
                User::get_by_userid($post['author_id']), $post['url_name']);
        }

        return $list;
    }

    public static function get_with_offset($count, $offset = 0)
    {
        $db = Db::getInstance();
        $count = intval($count);
        $offset = intval($offset);
        $req = $db->prepare('SELECT * FROM Post ORDER BY `time` desc LIMIT :count OFFSET :offset');
        $req->bindValue(':offset', $offset, PDO::PARAM_INT);
        $req->bindValue(':count', $count, PDO::PARAM_INT);
        $req->execute();
        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], Category::get_by_id($post['category_id']),
                $post['imgsrc'], $post['heading'], $post['description'],
                $post['text'], $post['tags'], $post['time'],
                User::get_by_userid($post['author_id']), $post['url_name']);
        }

        return $list;
    }

    public static function filter($filter)
    {
        $db = Db::getInstance();
        $filter = strval($filter);
        $req = $db->prepare("SELECT post.* FROM Post as post
                            JOIN User as user on (post.author_id = user.id)
                            JOIN Category as category on (post.category_id = category.id)
                            WHERE LOWER(post.heading) LIKE LOWER(:fltr) OR LOWER(post.description) LIKE LOWER(:fltr)
                                  OR LOWER(post.text) LIKE LOWER(:fltr) OR LOWER(post.tags) LIKE LOWER(:fltr)
                                  OR LOWER(category.cname) LIKE LOWER(:fltr) OR LOWER(CONCAT(user.first_name, ' ', user.second_name)) LIKE LOWER(:fltr)
                                  ORDER BY `time` desc");
        $req->bindValue(':fltr', "%$filter%");
        $req->execute();

        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], Category::get_by_id($post['category_id']),
                               $post['imgsrc'], $post['heading'], $post['description'],
                               $post['text'], $post['tags'], $post['time'],
                               User::get_by_userid($post['author_id']), $post['url_name']);
        }

        return $list;
    }

    public static function add_view($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
       
        $req = $db->prepare("UPDATE Post SET views = views + 1
                             WHERE id = :id");
        $req->execute(array(
            ':id' => $id
        ));
    }

    public static function get_by_views()
    {
        $list = [];
        $db = Db::getInstance();
        $req = $db->query('SELECT * FROM Post ORDER BY views desc');

        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], Category::get_by_id($post['category_id']),
                $post['imgsrc'], $post['heading'], $post['description'],
                $post['text'], $post['tags'], $post['time'],
                User::get_by_userid($post['author_id']), $post['url_name']);
        }

        return $list;
    }

    public static function get_hot()
    {
        $list = [];
        $db = Db::getInstance();
        $req = $db->query("SELECT * FROM Post as post LEFT JOIN (SELECT post_id, COUNT(*) as c_count
                           FROM Commentary
                           GROUP BY post_id) as cnt on (post.id = cnt.post_id) 
                           ORDER BY c_count DESC");

        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], Category::get_by_id($post['category_id']),
                $post['imgsrc'], $post['heading'], $post['description'],
                $post['text'], $post['tags'], $post['time'],
                User::get_by_userid($post['author_id']), $post['url_name']);
        }

        return $list;
    }
}
