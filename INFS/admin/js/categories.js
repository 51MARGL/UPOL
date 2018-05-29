$(document).ready(function () {
    $('#categoryForm').on('submit', function (e) {

        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
            type: 'POST',
            url: '/category/add_new/',
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

    $('.category-delete').on('click', function (e) {
        e.preventDefault();
        $.ajax({
            type: 'GET',
            url: "/category/before_delete/" + $(e.target).data("id"),
            success: function (jsonData) {
                var obj = $.parseJSON(jsonData);
                if (obj.success === 0) {
                    if (confirm(obj.error.message + "\nContinue?")) {
                        $.ajax({
                            type: 'POST',
                            url: $(e.target).attr("href"),
                            success: function (data) {
                                window.location.href = "/admin/categories/";
                            },
                            error: function () {
                                alert('Error occured');
                            }
                        });
                    }
                }
                else {
                    if (confirm("Are You sure?")) {
                        $.ajax({
                            type: 'POST',
                            url: $(e.target).attr("href"),
                            success: function (data) {
                                window.location.href = "/admin/categories/";
                            },
                            error: function () {
                                alert('Error occured');
                            }
                        });
                    }
                }
            },
            error: function () {
                alert('Error occured');
            }
        });
    });

    $('#editCategory').on('show.bs.modal', function (e) {

        //get data-id attribute of the clicked element
        var id = $(e.relatedTarget).data('id');
        var name = $(e.relatedTarget).data('name');
        var url_name = $(e.relatedTarget).data('url_name');
        var parent_id = $(e.relatedTarget).data('parent_id') == null
            || String($(e.relatedTarget).data('parent_id')).trim() == ''
            ? '-None-' : $(e.relatedTarget).data('parent_id');

        //populate the 
        $(e.currentTarget).find('input[name="id"]').val(id);
        $(e.currentTarget).find('input[name="name"]').val(name);
        $(e.currentTarget).find('input[name="url_name"]').val(url_name);
        $(e.currentTarget).find('select[name="parent_id"]').val(parent_id);

    });

    $('#editCategoryForm').on('submit', function (e) {

        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
            type: 'POST',
            url: '/category/edit/',
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

    $('div input[name="name"]').bind('input', function () {
        $('div input[name="url_name"]').val($(this).val().toLowerCase().replace(/[^\w_-]/g, "-").replace(/-{2,}/g, "-"));
    });



    $.ajax({
        type: 'GET',
        url: "/category/autocomplete_filter/",
        success: function (jsonData) {
            var autoList = $.parseJSON(jsonData);

            $(".autocomplete input").autocomplete(autoList, function () {
                if ($(".autocomplete input").val().length > 0) {
                    window.location.href = "/admin/categories/filter=" + escape($(".autocomplete input").val()) + "/";
                }
            });

        }
    });
});