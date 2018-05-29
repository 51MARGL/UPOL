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

    $(".search-form").on("submit", function (e) {
        e.preventDefault();
        if ($(".autocomplete input[name='filter']").val().match(/[^\&\w\s+,.!?@_-]/g)) {
            alert("Some invalid characters were found!");                  
        } else {
            window.location.href = "/home/posts/search/filter=" + escape($(".autocomplete input[name='filter']").val());
        }
    });

    $.ajax({
        type: 'GET',
        url: "/post/autocomplete_filter/",
        success: function (jsonData) {
            var autoList = $.parseJSON(jsonData);

            $(".autocomplete input").autocomplete(autoList, function(){});

        }
    });
});