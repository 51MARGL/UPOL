<?php require_once 'admin/views/pages/admin_header.php';?>

<header id="header">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <h1>
          <span class="material-icons">description</span> Posts
          <small>Manage Posts</small>
        </h1>
      </div>
    </div>
  </div>
</header>

<div class="container-fluid">
  <ul class="breadcrumb bg-dark text-white">
    <li class="breadcrumb-item active bg-dark text-white">Admin</li>
    <li class="breadcrumb-item active bg-dark text-white">Posts</li>
  </ul>
</div>

<main id="main">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-2">
        <div class="list-group">
          <a href="/admin/dashboard/" class="list-group-item text-dark ">
            <i class="material-icons">dashboard</i>
            <span>Dashboard</span>
            <span class="badge card bg-dark text-white">1</span>
          </a>
          <a href="/admin/categories/" class="list-group-item text-dark">
            <i class="material-icons">class</i>
            <span>Categories</span>
            <span class="badge card bg-dark text-white"><?php echo count(Category::all());?></span>
          </a>
          <a href="/admin/posts/" class="list-group-item active bg-dark">
            <i class="material-icons">description</i>
            <span>Posts</span>
          </a>
          <a href="/admin/users/" class="list-group-item text-dark">
            <i class="material-icons">people</i>
            <span>Users</span>
            <span class="badge card bg-dark text-white"><?php echo count(User::all());?></span>
          </a>
        </div>

      </div>
      <div class="col-md-10">
        <!-- Website Overview -->
        <div class="card">
          <div class="card-header bg-dark text-white card-header-btn">
            <h3>Posts</h3>
            <a class='btn btn-default bg-dark text-white' href='/admin/posts/add'>
              <i class="material-icons">note_add</i> Add New
            </a>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-12 autocomplete">
                <input class="form-control" type="text" value="<?php echo htmlspecialchars($_GET['filter'] ?? "");?>" placeholder="Filter Posts...">
              </div>
            </div>
            <br>
            <table class="table table-striped table-hover">
              <tr>
                <th>Title</th>
                <th>Category</th>
                <th>Author</th>
                <th>Date</th>
                <th></th>
              </tr>
              <?php
$rows = '';
foreach ($postsToDisplay as $post) {
    $heading = htmlspecialchars($post->heading);
    $category = htmlspecialchars($post->category->name);
    $first_name = htmlspecialchars($post->author->first_name);
    $second_name = htmlspecialchars($post->author->second_name);
    $date = (new DateTime($post->time))->format('F d, Y');
    $editDelete = '';
    if (unserialize($_SESSION['current_user'])->rights == 'SA'
        || unserialize($_SESSION['current_user'])->id == $post->author->id) {
        $editDelete = "<a class='btn btn-dark' href='/admin/posts/edit/$post->id'>Edit</a>
                       <a class='btn btn-danger post-delete' href='/post/delete/$post->id'>Delete</a>";
    }
    $rows .= "<tr>
                <td>$heading</td>
                <td>$category</td>
                <td>$first_name $second_name</td>
                <td>$date</td>
                <td>$editDelete</td>
              </tr>";
}
echo $rows;
?>
            </table>

            <?php require_once "admin/views/pages/pagination.php"?>

          </div>
        </div>
      </div>
    </div>
  </div>
</main>

<script src="/admin/js/autocomplete.js"></script>
<script src="/admin/js/posts.js"></script>