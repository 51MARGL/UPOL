$(document).ready(function () {
    $(window).scroll(function () {
        if ($(this).scrollTop() >= 500) {
            $('.scrollToTop').fadeIn();
        } else {
            $('.scrollToTop').fadeOut();
        }
    });

    $('.scrollToTop').click(function () {
        $('html, body').animate({ scrollTop: 0 }, 800);
        return false;
    });

    $('#commentForm').on('submit', function (e) {
        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
            type: 'POST',
            url: '/commentary/add_new/',
            data: formData,
            success: function (jsonData) {
                var obj = $.parseJSON(jsonData);
                if (obj.success === 0) {
                    alert(obj.error.message);
                }
                else {
                    alert('Successfuly created');
                    window.location.reload(true);
                }
            },
            error: function () {
                alert('Error occured. Form was not submitted');
            },
            contentType: false,
            processData: false
        });
    });

    $(".comment-section .reply-to").on("click", function () {
        $("#commentForm input[name='reply_id']").val($(this).data("id"));
        $(".reply .reply-to-person").show();
        $(".reply-to-person .name-hold").html("Replying to: " + $(this).closest('.post-content').find("h3").html());
        $("#commentForm textarea[name='text']").focus();
    });

    $(".reply .remove-reply").on("click", function () {
        $("#commentForm input[name='reply_id']").val("");
        $(".reply .reply-to-person").hide();
        $(".reply-to-person .name-hold").html("");
    });

    $(".delete-reply").on("click", function () {
        if (!confirm("Are You sure?")) {
            id = $(this).data("id");
            $.ajax({
                type: 'POST',
                url: '/commentary/delete/' + id,
                success: function () {
                    alert('Successfuly deleted');
                    window.location.reload(true);
                },
                error: function () {
                    alert('Error occured');
                }
            });
        }
    });

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
        on:
            {
                instanceReady: function (evt) {
                    toggleReadOnly(true);
                }
            },
        // Since we define all configuration options here, let's instruct CKEditor to not load config.js which it does by default.
        // One HTTP request less will result in a faster startup time.
        // For more information check http://docs.ckeditor.com/ckeditor4/docs/#!/api/CKEDITOR.config-cfg-customConfig
        // Enabling extra plugins, available in the standard-all preset: http://ckeditor.com/presets-all
        extraPlugins: 'autoembed,embedsemantic,image2,uploadimage,justify,indentblock,autogrow',

        autoGrow_onStartup: true,
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
        removePlugins: 'image,contextmenu,liststyle,tabletools,tableselection',

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

            // Media embed
            { name: '240p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-240p' } },
            { name: '360p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-360p' } },
            { name: '480p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-480p' } },
            { name: '720p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-720p' } },
            { name: '1080p', type: 'widget', widget: 'embedSemantic', attributes: { 'class': 'embed-1080p' } }
        ]
    });

    function toggleReadOnly(value) {
        $("#cke_editor1 .cke_top").css({ display: 'none' });
        $("#cke_editor1 .cke_bottom").css({ display: 'none' });
        $("iframe").contents().find(".cke_editable").css({
            "font-family": "Open Sans, sans-serif",
            "font-size": "16px",
            "margin": "0px"
        });
        $("iframe").contents().find("span .cke_widget_drag_handler_container").remove();
        $("iframe").contents().find(".cke_widget_wrapper .cke_widget_element").css({ "outline": "none" });
        $("span.cke_skin_kama").css({ "border": "none", "margin": "0px" });
    }
});