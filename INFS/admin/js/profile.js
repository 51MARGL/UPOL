$(document).ready(function () {   
    $('#editUser').on('show.bs.modal', function (e) {

        //get data-id attribute of the clicked element
        var id = $(e.relatedTarget).data('id');
        var username = $(e.relatedTarget).data('username');
        var email = $(e.relatedTarget).data('email');
        var first_name = $(e.relatedTarget).data('first_name');
        var second_name = $(e.relatedTarget).data('second_name');
        var profile_img = $(e.relatedTarget).data('profile_img');
        var about = $(e.relatedTarget).data('about');

        //populate the 
        $(e.currentTarget).find('input[name="id"]').val(id);
        $(e.currentTarget).find('input[name="username"]').val(username);
        $(e.currentTarget).find('input[name="email"]').val(email);
        $(e.currentTarget).find('input[name="first_name"]').val(first_name);
        $(e.currentTarget).find('input[name="second_name"]').val(second_name);
        CKEDITOR.instances.editor2.setData(about);
    });

    $('#userFormEdit').on('submit', function (e) {

        e.preventDefault();
        for (instance in CKEDITOR.instances) {
            CKEDITOR.instances[instance].updateElement();
        }        
        var formData = new FormData(this);
        $.ajax({
            type: 'POST',
            url: '/user/edit/',
            data: formData,
            success: function (jsonData) {
                var obj = $.parseJSON(jsonData);
                if (obj.success === 0) {
                    alert(obj.error.message);
                }
                else {
                    alert('Successfuly updated');
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
});