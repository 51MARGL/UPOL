<?php require_once 'admin/views/pages/admin_header.php';?>

<header id="header">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <h1>
          <span class="material-icons">description</span> Posts
          <small>Edit Post</small>
        </h1>
      </div>
    </div>
  </div>
</header>

<div class="container-fluid">
  <ul class="breadcrumb bg-dark text-white">
    <li class="breadcrumb-item active bg-dark text-white">Admin</li>
    <li class="breadcrumb-item active bg-dark text-white">Users</li>
    <li class="breadcrumb-item active bg-dark text-white">Profile</li>
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
          <a href="/admin/categories/" class="list-group-item text-dark ">
            <i class="material-icons">class</i>
            <span>Categories</span>
            <span class="badge card bg-dark text-white">12</span>
          </a>
          <a href="/admin/posts/" class="list-group-item text-dark">
            <i class="material-icons">description</i>
            <span>Posts</span>
            <span class="badge card bg-dark text-white">33</span>
          </a>
          <a href="/admin/users/" class="list-group-item active bg-dark">
            <i class="material-icons">people</i>
            <span>Users</span>
          </a>
        </div>
      </div>

      <div class="col-md-10">
        <div class="card bg-dark text-white">

          <h3 class="card-header bg-dark text-white">User Profile</h3>

          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-md-3 profile-img text-center">
                <img class="mx-auto d-block"  src="<?php echo htmlspecialchars($user_for_profile->profile_img); ?>" alt="profile_image" class="src">
                <h4 style="text-align:center;">
                  <?php echo htmlspecialchars($user_for_profile->first_name . " " . $user_for_profile->second_name); ?>
                </h4>

              </div>
              <div class="col-md-3">
                <p>Email: <?php echo htmlspecialchars($user_for_profile->email) ?></p>
                <p>Posts: <?php echo '12' ?></p>
                <p>Comments left: <?php echo '35' ?></p>
              </div>
              <div class="col-md-6">
                <p>About:</p>
                <textarea disabled name="editor1" class="form-control" placeholder="About">
                  <?php echo htmlspecialchars($user_for_profile->about) ?>
                </textarea>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>


<script>
  $(document).ready(function () {
    CKEDITOR.replace('editor1', {
      language: 'en',
      // Define the toolbar: http://docs.ckeditor.com/ckeditor4/docs/#!/guide/dev_toolbar
      // The standard preset from CDN which we used as a base provides more features than we need.
      // Also by default it comes with a 2-line toolbar. Here we put all buttons in a single row.
      toolbar: [
        ['Undo', 'Redo'],
        ['Styles', 'Format'],
        ['Bold', 'Italic', 'Strike', '-', 'RemoveFormat'],
        ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent'],
        ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'Blockquote'],
        ['Link', 'Unlink'],
        ['Image', 'EmbedSemantic', 'Table'],
        ['Maximize'],
        ['Scayt']
      ],
      on :
        {
            instanceReady : function ( evt )
            {
              toggleReadOnly(true);
            }
        },
      // Since we define all configuration options here, let's instruct CKEditor to not load config.js which it does by default.
      // One HTTP request less will result in a faster startup time.
      // For more information check http://docs.ckeditor.com/ckeditor4/docs/#!/api/CKEDITOR.config-cfg-customConfig
      // Enabling extra plugins, available in the standard-all preset: http://ckeditor.com/presets-all
      extraPlugins: 'autoembed,embedsemantic,image2,uploadimage,justify,indentblock',
      /*********************** File management support ***********************/
      // In order to turn on support for file uploads, CKEditor has to be configured to use some server side
      // solution with file upload/management capabilities, like for example CKFinder.
      // For more information see http://docs.ckeditor.com/ckeditor4/docs/#!/guide/dev_ckfinder_integration
      // Uncomment and correct these lines after you setup your local CKFinder instance.
      // filebrowserBrowseUrl: '/ckfinder/ckfinder.html',
      //filebrowserUploadUrl: '/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Files',
      filebrowserUploadUrl: '/uploader/upload.php?command=QuickUpload&type=Files',
      /*********************** File management support ***********************/
      // Remove the default image plugin because image2, which offers captions for images, was enabled above.
      removePlugins: 'image',
      // Make the editing area bigger than default.
      height: 150,
      // This is optional, but will let us define multiple different styles for multiple editors using the same CSS file.
      bodyClass: 'article-editor',
      // Reduce the list of block elements listed in the Format dropdown to the most commonly used.
      format_tags: 'p;h1;h2;h3;pre',
      // Simplify the Image and Link dialog windows. The "Advanced" tab is not needed in most cases.
      removeDialogTabs: 'image:advanced;link:advanced',
      // Define the list of styles which should be available in the Styles dropdown list.
      // If the "class" attribute is used to style an element, make sure to define the style for the class in "mystyles.css"
      // (and on your website so that it rendered in the same way).
      // Note: by default CKEditor looks for styles.js file. Defining stylesSet inline (as below) stops CKEditor from loading
      // that file, which means one HTTP request less (and a faster startup).
      // For more information see http://docs.ckeditor.com/ckeditor4/docs/#!/guide/dev_styles
      stylesSet: [
        /* Inline Styles */
        { name: 'Marker', element: 'span', attributes: { 'class': 'marker' } },
        { name: 'Cited Work', element: 'cite' },
        { name: 'Inline Quotation', element: 'q' },
        /* Object Styles */
        {
          name: 'Special Container',
          element: 'div',
          styles: {
            padding: '5px 10px',
            background: '#eee',
            border: '1px solid #ccc'
          }
        },
        {
          name: 'Compact table',
          element: 'table',
          attributes: {
            cellpadding: '5',
            cellspacing: '0',
            border: '1',
            bordercolor: '#ccc'
          },
          styles: {
            'border-collapse': 'collapse'
          }
        },
        { name: 'Borderless Table', element: 'table', styles: { 'border-style': 'hidden', 'background-color': '#E6E6FA' } },
        { name: 'Square Bulleted List', element: 'ul', styles: { 'list-style-type': 'square' } },
        /* Widget Styles */
        // We use this one to style the brownie picture.
        { name: 'Illustration', type: 'widget', widget: 'image', attributes: { 'class': 'image-illustration' } },
        // Media embed
        { name: '240p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-240p' } },
        { name: '360p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-360p' } },
        { name: '480p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-480p' } },
        { name: '720p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-720p' } },
        { name: '1080p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-1080p' } }
      ]
    });

    function toggleReadOnly(value){
      $(".cke_top").css({display: 'none'});
      $(".cke_bottom").css({display: 'none'});
    }
  });
  </script>