<nav class="navbar navbar-expand-md bg-dark navbar-dark">
    <!-- Brand -->
    <a class="navbar-brand" href="/admin/dashboard/">AdminPanel</a>
  
    <!-- Toggler/collapsibe Button -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
  
    <!-- Navbar links -->
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="/home/">Home</a>
        </li>
      </ul>
    </div>
  </nav>

<header id="header-login">
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <h1 class="text-center"><i class="material-icons">person</i> Account Login</h1>
      </div>
    </div>
  </div>
</header>

<main id="main">
  <div class="container">
    <div class="row align-items-center justify-content-center">
      <div class="col-md-4">
        <form id="login" action="/user/login/" method="post">

          <?php if (isset($error)) { ?>
            <p style="color:#ff0000"><?php echo $error?></p>
          <?php } ?>

          <div class="form-group">
            <label>Username</label>
            <input type="text" required value="<?php echo htmlspecialchars($username); ?>" name="username" class="form-control" placeholder="User Name">
          </div>
          <div class="form-group">
            <label>Password</label>
            <input type="password" required	name="password" class="form-control" placeholder="Password">
          </div>
          <button type="submit" class=" col-md-12 btn btn-default bg-dark text-white">Login</button>
        </form>
      </div>
    </div>
  </div>
</main>