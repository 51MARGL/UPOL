<?php require_once('admin/views/pages/admin_header.php'); ?>
  <header id="header">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-12">
          <h1>
            <span class="material-icons">dashboard</span> Dashboard
            <small>Manage Your Site</small>
          </h1>
        </div>        
      </div>
    </div>
  </header>
  
    <div class="container-fluid">
      <ul class="breadcrumb bg-dark text-white">
        <li class="breadcrumb-item active bg-dark text-white">Admin</li>
        <li class="breadcrumb-item active bg-dark text-white">Dashboard</li>
      </ul>
    </div>
  
  <main id="main">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-2">
          <div class="list-group">
            <a href="/admin/dashboard/" class="list-group-item active bg-dark">
              <i class="material-icons">dashboard</i><span>Dashboard</span>
            </a>
            <a href="/admin/categories/" class="list-group-item text-dark">
              <i class="material-icons">class</i> <span>Categories</span>
              <span class="badge card bg-dark text-white"><?php echo count(Category::all());?></span>
            </a>
            <a href="/admin/posts/" class="list-group-item text-dark">
              <i class="material-icons">description</i> <span>Posts</span>
              <span class="badge card bg-dark text-white"><?php echo count(Post::all());?></span>
            </a>
            <a href="/admin/users/" class="list-group-item text-dark">
              <i class="material-icons">people</i> <span>Users</span>
              <span class="badge card bg-dark text-white"><?php echo count(User::all());?></span>
            </a>
          </div>
  
        </div>

        <div class="col-md-10">
          <!-- Website Overview -->
          <div class="card">
  
            <h3 class="card-header bg-dark text-white">Website Overview</h3>
  
            <div class="row justify-content-between">            
              <div class="col-md-3">
                <div class="card card-body bg-light">
                  <h2>
                    <i class="material-icons">people</i><?php echo count(User::all());?></h2>
                  <h4>Users</h4>
                </div>
              </div>
                        
              <div class="col-md-3">
                <div class="card card-body bg-light">
                  <h2>
                  <i class="material-icons">class</i></span><?php echo count(Category::all());?></h2>
                  <h4>Categories</h4>
                </div>
              </div>
                    
              <div class="col-md-3">
                <div class="card card-body bg-light">
                  <h2>
                  <i class="material-icons">description</i><?php echo count(Post::all());?></h2>
                  <h4>Posts</h4>
                </div>
              </div>
            </div>
          </div>
  
          <!-- Latest Posts -->
          <div class="card">
            <div class="card-header bg-dark text-white card-header-btn">
              <h3>Latest Posts</h3>
              <a class='btn btn-default bg-dark text-white' href='/admin/posts/add'>
                <i class="material-icons">note_add</i> Add New
              </a>
            </div>
            <div class="card-body">
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
