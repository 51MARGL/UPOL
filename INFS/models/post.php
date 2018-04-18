<?php
class Post
{
    public $id;
    public $category;
    public $imgsrc;
    public $heading;
    public $text;
    public $time;
    public $author;

    public function __construct($id, $category, $imgsrc, $heading, $text, $time, $author)
    {
        $this->id = $id;
        $this->category = $category;
        $this->imgsrc = $imgsrc;
        $this->heading = $heading;
        $this->text = $text;
        $this->time = $time;
        $this->author = $author;
    }

    public static function all()
    {
        $list = [];
        $db = Db::getInstance();
        $req = $db->query('SELECT * FROM Post');
        
        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], $post['category'],
                               $post['imgsrc'], $post['heading'],
                               $post['text'], $post['time'], $post['author']);
        }

        return $list;
    }

    public static function find($id)
    {
        $db = Db::getInstance();        
        $id = intval($id);
        $req = $db->prepare('SELECT * FROM Post WHERE id = :id');        
        $req->execute(array('id' => $id));
        $post = $req->fetch();
        return new Post($post['id'], $post['category'],
                        $post['imgsrc'], $post['heading'],
                        $post['text'], $post['time'], $post['author']);
    }

    public static function getByCategory($category, $count, $offset = 0)
    {
        $db = Db::getInstance();
        
        $count = intval($count);
        $offset = intval($offset);
        $category = strval($category);               
        $req = $db->prepare('SELECT * FROM Post WHERE category = :category LIMIT :count OFFSET :offset');
        $req->bindValue(':category', $category, PDO::PARAM_STR); 
        $req->bindValue(':offset', $offset, PDO::PARAM_INT); 
        $req->bindValue(':count', $count, PDO::PARAM_INT);         
        $req->execute();
        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], $post['category'],
                               $post['imgsrc'], $post['heading'],
                               $post['text'], $post['time'], $post['author']);
        }

        return $list;
    }

    public static function getCount($count, $offset = 0)
    {
        $db = Db::getInstance();
        $count = intval($count);
        $offset = intval($offset);
        $req = $db->prepare('SELECT * FROM Post LIMIT :count OFFSET :offset');         
        $req->bindValue(':offset', $offset, PDO::PARAM_INT); 
        $req->bindValue(':count', $count, PDO::PARAM_INT);       
        $req->execute();      
        foreach ($req->fetchAll() as $post) {
            $list[] = new Post($post['id'], $post['category'],
                               $post['imgsrc'], $post['heading'],
                               $post['text'], $post['time'], $post['author']);
        }

        return $list;
    }
}
