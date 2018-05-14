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
              <span class="badge card bg-dark text-white">12</span>
            </a>
            <a href="/admin/posts/" class="list-group-item text-dark">
              <i class="material-icons">description</i> <span>Posts</span>
              <span class="badge card bg-dark text-white">33</span>
            </a>
            <a href="/admin/users/" class="list-group-item text-dark">
              <i class="material-icons">people</i> <span>Users</span>
              <span class="badge card bg-dark text-white">203</span>
            </a>
          </div>
  
        </div>

        <div class="col-md-10">
          <!-- Website Overview -->
          <div class="card">
  
            <h3 class="card-header bg-dark text-white">Website Overview</h3>
  
            <div class="row">
              <div class="col-md-3">
                <div class="card card-body bg-light">
                  <h2>
                    <i class="material-icons">people</i> 203</h2>
                  <h4>Users</h4>
                </div>
              </div>
              <div class="col-md-3">
                <div class="card card-body bg-light">
                  <h2>
                  <i class="material-icons">class</i></span> 12</h2>
                  <h4>Categories</h4>
                </div>
              </div>
              <div class="col-md-3">
                <div class="card card-body bg-light">
                  <h2>
                  <i class="material-icons">description</i> 33</h2>
                  <h4>Posts</h4>
                </div>
              </div>
              <div class="col-md-3">
                <div class="card card-body bg-light">
                  <h2>
                  <i class="material-icons">assessment</i> 12,334</h2>
                  <h4>Visitors</h4>
                </div>
              </div>
            </div>
          </div>
  
          <!-- Latest Posts -->
          <div class="card">
            <div class="card-header bg-dark text-white">
              <h3>Latest Posts</h3>
            </div>
            <div class="card-body">
              <table class="table table-striped table-hover">
                <tr>
                  <th>Title</th>
                  <th>Author</th>
                  <th>Created</th>
                  <th></th>
                </tr>
                <tr>
                  <td>Blog Post 1</td>
                  <td>John Doe</td>
                  <td>Dec 12, 2016</td>
                  <td><a class="btn btn-default" href="/admin/edit/">Edit</a> <a class="btn btn-danger" href="#">Delete</a></td>
                </tr>
                <tr>
                  <td>Blog Post 2</td>
                  <td>John Doe</td>
                  <td>Dec 13, 2016</td>
                  <td><a class="btn btn-default" href="/admin/edit/">Edit</a> <a class="btn btn-danger" href="#">Delete</a></td>
                </tr>
                <tr>
                  <td>Blog Post 3</td>
                  <td>John Doe</td>
                  <td>Dec 13, 2016</td>
                  <td><a class="btn btn-default" href="/admin/edit/">Edit</a> <a class="btn btn-danger" href="#">Delete</a></td>
                </tr>
                <tr>
                  <td>Blog Post 4</td>
                  <td>John Doe</td>
                  <td>Dec 14, 2016</td>
                  <td><a class="btn btn-default" href="/admin/edit/">Edit</a> <a class="btn btn-danger" href="#">Delete</a></td>
                </tr>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
