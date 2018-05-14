$(document).ready(function () {
    $('#userForm').on('submit', function (e) {

        e.preventDefault();
        for ( instance in CKEDITOR.instances ) {
            CKEDITOR.instances[instance].updateElement();
        }
        var formData = new FormData(this);
        $.ajax({
            type: 'POST',
            url: '/user/add_new/',
            data: $('#userForm').serialize(),
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

    $('.user-delete').on('click', function (e) {
        if (!confirm("Are You sure?")) {
            e.preventDefault();
        }
    });
});