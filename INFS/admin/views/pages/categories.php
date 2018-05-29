<?php require_once('admin/views/pages/admin_header.php'); ?>

  <header id="header">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-12">
          <h1>
            <span class="material-icons">class</span> Categories
            <small>Manage Categories</small>
          </h1>
        </div>        
      </div>
    </div>
  </header>

  <div class="container-fluid">
    <ul class="breadcrumb bg-dark text-white">
      <li class="breadcrumb-item active bg-dark text-white">Admin</li>
      <li class="breadcrumb-item active bg-dark text-white">Categories</li>
    </ul>
  </div>

  <main id="main">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-2">
          <div class="list-group">
            <a href="/admin/dashboard/" class="list-group-item text-dark ">
              <i class="material-icons">dashboard</i><span>Dashboard</span>
              <span class="badge card bg-dark text-white">1</span>
            </a>
            <a href="/admin/categories/" class="list-group-item active bg-dark">
              <i class="material-icons">class</i> <span>Categories</span>              
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
          <div class="card-header bg-dark text-white card-header-btn">
            <h3 class="inline-block">Categories</h3>

            <?php if (unserialize($_SESSION['current_user'])->rights == 'SA' || unserialize($_SESSION['current_user'])->rights == 'A') { ?>
              <button class="btn btn-default bg-dark text-white" type="button" data-toggle="modal" data-target="#addCategory">
                <i class="material-icons">note_add</i> Add New
              </button>
            <?php } ?>

            
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-12 autocomplete">
                <input class="form-control" type="text" value="<?php echo htmlspecialchars($_GET['filter'] ?? "");?>" placeholder="Filter Categories...">
              </div>
            </div>
            <br>
            <table class="table table-striped table-hover">
              <tr>
                <th>Name</th>
                <th>URL Name</th>
                <th>Parent Category</th>               
                <th></th>
              </tr>
              <?php
$rows = '';
foreach ($categoriesToDisplay as $category) {
    $name = htmlspecialchars($category->name);
    $url_name = htmlspecialchars($category->url_name);
    $parent_name = htmlspecialchars($category->parent_name);
    $parent_id = htmlspecialchars($category->parent_id);
    $delete='';
    $edit='';
    if (unserialize($_SESSION['current_user'])->rights == 'SA') {
        $delete = "<a class='btn btn-danger category-delete' data-id='$category->id' href='/category/delete/$category->id'>Delete</a>";
    }
    if (unserialize($_SESSION['current_user'])->rights == 'SA' || unserialize($_SESSION['current_user'])->rights == 'A') {
      $edit = "<button class='btn btn-dark' type='button' data-toggle='modal' data-target='#editCategory'
                data-id='$category->id' data-name='$name' data-url_name='$url_name' data-parent_name='$parent_name' data-parent_id='$parent_id'>Edit
                </button>";
  }
    $rows .= "<tr>
                <td>$name</td>
                <td>$url_name</td>
                <td>$parent_name</td>
                <td>$edit $delete</td> 
              </tr>";
}
echo $rows;
?>
            </table>

            <?php require_once "admin/views/pages/pagination.php" ?>

          </div>
        </div>

      </div>
    </div>
  </div>
</section>
<!-- Modals -->

<!-- Add Category -->
<div class="modal fade" id="addCategory" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form id="categoryForm" action="/user/add_new/" method="post">
        <div class="modal-header">
          <h4 class="modal-title" id="myModalLabel">Add Category</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>Name</label>
            <input name="name" type="text" class="form-control" placeholder="Name">
          </div>
          <div class="form-group">
            <label>Category URL Name</label>
            <input name="url_name" type="text" class="form-control" placeholder="URL Name">
          </div>
          <div class="form-group">
            <label for="sel1">Parent Category:</label>
            <select name="parent_id" class="form-control" id="sel1">
              <option>-None-</option>
              <?php
              foreach($categories as $category){
                echo "<option value='$category->id'>" . htmlspecialchars($category->name) . "</option>";
              }
              ?>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-dark">Save changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="editCategory" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <form id="editCategoryForm" action="/user/add_new/" method="post">
        <div class="modal-header">
          <h4 class="modal-title" id="myModalLabel2">Edit Category</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>Category Name</label>
            <input name="name" required type="text" class="form-control" placeholder="Name">
          </div>
          <div class="form-group">
            <label>Category URL Name</label>
            <input name="url_name" type="text" class="form-control" placeholder="URL Name">
          </div>
          <div class="form-group">
            <label for="sel1">Parent Category:</label>
            <select name="parent_id" class="form-control" id="sel1">
              <option>-None-</option>
              <?php
              foreach($categories as $category){
                echo "<option value='$category->id'>" . htmlspecialchars($category->name) . "</option>";
              }
              ?>
            </select>
          </div>
        </div>
        <input name="id" type="hidden"	class="form-control">                
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-dark">Save changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="/admin/js/autocomplete.js"></script>
<script src="/admin/js/categories.js"></script>