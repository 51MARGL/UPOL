<?php
class Category
{
    public $id;
    public $name;
    public $url_name;
    public $parent_id;
    public $parent_name;

    public function __construct($id, $name, $url_name, $parent_id, $parent_name)
    {
        $this->id = $id;
        $this->name = $name;
        $this->url_name = $url_name;
        $this->parent_id = $parent_id;
        $this->parent_name = $parent_name;
    }

    public static function add_new($name, $url_name, $parent_id)
    {
        $db = Db::getInstance();
        $name = strval($name);
        $url_name = strval($url_name);
        $parent_id = intval($parent_id);
        if (empty($parent_id)) {
            $req = $db->prepare("INSERT INTO Category (cname, url_name)
                             VALUES (:nm, :unm)");
            $req->execute(array(
                ':nm' => $name,
                ':unm' => $url_name
            ));
        } else {
            $req = $db->prepare("INSERT INTO Category (cname, url_name, parent_id)
                             VALUES (:nm, :unm,:pid)");
            $req->execute(array(
                ':nm' => $name,
                ':pid' => $parent_id,
                ':unm' => $url_name
            ));
        }
    }

    public static function edit($id, $name, $url_name, $parent_id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $name = strval($name);
        $url_name = strval($url_name);
        $parent_id = intval($parent_id);
        if (empty($parent_id)) {
            $req = $db->prepare("UPDATE Category SET cname = :nm, url_name = :unm, parent_id = null
                            WHERE id = :id;");
            $req->execute(array(
                ':nm' => $name,
                ':unm' => $url_name,
                ':id' => $id
            ));
        } else {
            $req = $db->prepare("UPDATE Category SET cname = :nm, url_name = :unm, parent_id = :pid
                            WHERE id = :id;");
            $req->execute(array(
                ':nm' => $name,
                ':unm' => $url_name,
                ':pid' => $parent_id,
                ':id' => $id
            ));
        }
    }

    public static function get_by_id($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('SELECT ch.*, rt.id as parent_id, rt.cname as parent_name
                             FROM Category as ch
                             LEFT JOIN Category as rt ON (ch.parent_id = rt.id)
                             WHERE ch.id = :id');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
        $category = $req->fetch();
        return new Category($category['id'], $category['cname'], $category['url_name'],
            $category['parent_id'], $category['parent_name']);
    }

    public static function get_by_cname($name)
    {
        $db = Db::getInstance();
        $name = strval($name);
        $req = $db->prepare('SELECT ch.*, rt.id as parent_id, rt.cname as parent_name
                             FROM Category as ch
                             LEFT JOIN Category as rt ON (ch.parent_id = rt.id)
                             WHERE ch.cname = :nm');
        $req->execute(array(
            ':nm' => $name
        ));
        $category = $req->fetch();
        return new Category($category['id'], $category['cname'], $category['url_name'],
            $category['parent_id'], $category['parent_name']);
    }

    public static function get_by_url_name($url_name)
    {
        $db = Db::getInstance();
        $url_name = strval($url_name);
        $req = $db->prepare('SELECT ch.*, rt.id as parent_id, rt.cname as parent_name
                             FROM Category as ch
                             LEFT JOIN Category as rt ON (ch.parent_id = rt.id)
                             WHERE ch.url_name = :unm');
        $req->execute(array(
            ':unm' => $url_name
        ));
        $category = $req->fetch();
        return new Category($category['id'], $category['cname'], $category['url_name'],
            $category['parent_id'], $category['parent_name']);
    }

    public static function get_by_parent_id($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('SELECT ch.*, rt.id as parent_id, rt.cname as parent_name
                             FROM Category as ch
                             LEFT JOIN Category as rt ON (ch.parent_id = rt.id)
                             WHERE rt.id = :id');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();

        foreach ($req->fetchAll() as $category) {
            $list[] = new Category($category['id'], $category['cname'], $category['url_name'],
                $category['parent_id'], $category['parent_name']);
        }

        return $list;
    }

    public static function all()
    {
        $list = [];
        $db = Db::getInstance();
        $req = $db->query('SELECT ch.*, rt.id as parent_id, rt.cname as parent_name
                           FROM Category as ch
                           LEFT JOIN Category as rt ON (ch.parent_id = rt.id)');

        foreach ($req->fetchAll() as $category) {
            $list[] = new Category($category['id'], $category['cname'], $category['url_name'],
                $category['parent_id'], $category['parent_name']);
        }

        return $list;
    }

    public static function filter($filter)
    {
        $db = Db::getInstance();
        $filter = strval($filter);
        $req = $db->prepare("SELECT ch.*, rt.id as parent_id, rt.cname as parent_name
                             FROM Category as ch
                             LEFT JOIN Category as rt ON (ch.parent_id = rt.id)
                             WHERE LOWER(ch.cname) LIKE LOWER(:fltr) OR LOWER(ch.url_name) LIKE LOWER(:fltr)
                                    OR LOWER(rt.cname) LIKE LOWER(:fltr)");
        $req->bindValue(':fltr', "%$filter%");
        $req->execute();

        foreach ($req->fetchAll() as $category) {
            $list[] = new Category($category['id'], $category['cname'], $category['url_name'],
                $category['parent_id'], $category['parent_name']);
        }

        return $list;
    }

    public static function get_with_offset($count, $offset = 0)
    {
        $list = [];
        $db = Db::getInstance();
        $count = intval($count);
        $offset = intval($offset);

        $req = $db->prepare('SELECT ch.*, rt.id as parent_id, rt.cname as parent_name
                             FROM Category as ch
                             LEFT JOIN Category as rt ON (ch.parent_id = rt.id)
                             LIMIT :count OFFSET :offset');
        $req->bindValue(':offset', $offset, PDO::PARAM_INT);
        $req->bindValue(':count', $count, PDO::PARAM_INT);
        $req->execute();

        foreach ($req->fetchAll() as $category) {
            $list[] = new Category($category['id'], $category['cname'], $category['url_name'],
                $category['parent_id'], $category['parent_name']);
        }

        return $list;
    }

    public static function delete($id)
    {
        $db = Db::getInstance();
        $id = intval($id);
        $req = $db->prepare('DELETE FROM Category WHERE id = :id');
        $req->bindValue(':id', $id, PDO::PARAM_INT);
        $req->execute();
    }
}
