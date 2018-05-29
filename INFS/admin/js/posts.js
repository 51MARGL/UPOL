$(document).ready(function () {
    $('.post-delete').on('click', function (e) {
        if (!confirm("Are You sure?")) {
            e.preventDefault();
        }
    });

    $.ajax({
        type: 'GET',
        url: "/post/autocomplete_filter/",
        success: function (jsonData) {
            var autoList = $.parseJSON(jsonData);

            $(".autocomplete input").autocomplete(autoList, function () {
                if ($(".autocomplete input").val().length > 0) {
                    window.location.href = "/admin/posts/filter=" + escape($(".autocomplete input").val()) + "/";
                }
            });

        }
    });
});