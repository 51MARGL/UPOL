$(document).ready(function () {
    $('#postFormAdd').on('submit', function (e) {

        e.preventDefault();
        for (instance in CKEDITOR.instances) {
            CKEDITOR.instances[instance].updateElement();
        }
        var formData = new FormData(this);
        $.ajax({
            type: 'POST',
            url: '/post/add_new/',
            data: formData,
            success: function (jsonData) {
                var obj = $.parseJSON(jsonData);
                if (obj.success === 0) {
                    alert(obj.error.message);
                }
                else {
                    alert('Successfuly created');
                    window.location.href = "/admin/posts/";
                }
            },
            error: function () {
                alert('Error occured. Form was not submitted');
            },
            contentType: false,
            processData: false
        });
    });

    $('#postFormEdit').on('submit', function (e) {

        e.preventDefault();
        for (instance in CKEDITOR.instances) {
            CKEDITOR.instances[instance].updateElement();
        }
        var formData = new FormData(this);
        $.ajax({
            type: 'POST',
            url: '/post/edit/',
            data: formData,
            success: function (jsonData) {
                var obj = $.parseJSON(jsonData);
                if (obj.success === 0) {
                    alert(obj.error.message);
                }
                else {
                    alert('Successfuly updated');
                    window.location.href = "/admin/posts/";
                }
            },
            error: function () {
                alert('Error occured. Form was not submitted');
            },
            contentType: false,
            processData: false
        });
    });

    $('div input[name="title"]').on('input', function () {
        $('div input[name="url_name"]').val($(this).val().toLowerCase().replace(/[^\w_-]/g, "-").replace(/-{2,}/g, "-"));
    });

    $(".tags-form").on('click', function () {
        $(".tags-form input[type='text'").focus();
    });    

    $(".tags-form").tagsForm();
});