$(document).ready(function () {

    var slideIndex = 0;
    var interval_id;

    //foreground vs background
    $(window).on("blur focus", function (e) {
        switch (e.type) {
            case "focus":
                if (!interval_id)
                    interval_id = setInterval(slideThroughList, 6000);
                break;
            case "blur":
                clearInterval(interval_id);
                interval_id = 0;
                break;
        }
    })

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

    function slideThroughList() {
        var $postList = $(".slider .post-preview");
        var $bigPost = $(".slider .selected-post-preview");
        var temp = $bigPost.html();

        $postList.eq(slideIndex).animate({
            right: '500px',
            opacity: 0
        }, 1000, function () {
            var offset1 = $bigPost.offset();

            $bigPost.before('<article class="selected-post-preview white">' +
                $postList.eq(slideIndex).html() +
                '</article>');
            $(".slider .selected-post-preview-container")
                .find('article').eq(1)
                .fadeOut(1000, function () {
                    $(".slider .selected-post-preview-container").find('article').eq(1).remove();
                });
            $postList.eq(slideIndex).html(temp);
            $postList.eq(slideIndex).animate({
                right: '0px',
                opacity: 1
            }, 1000, function () {
                slideIndex = (slideIndex + 1) % $postList.length;
            });
        });
    }

    function loadSliderAsync() {
        $.ajax({
            url: '/index.php?controller=posts&action=getCount',
            type: 'GET',
            data: "count=6",
            success: function (data) {
                $data = $(data).filter("div");
                $(".slider .selected-post-preview").html($data.eq(0).html());
                $(".slider .post-preview").each(function (index, element) {
                    var elem = $(element);
                    elem.html($data.eq(index + 1).html());
                });

                if (!interval_id)
                    interval_id = setInterval(slideThroughList, 6000);
            }
        });
    }

    function loadWorldAsync() {
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategoryDetailed',
            type: 'GET',
            data: "category=World&count=3",
            success: function (data) {
                $data = $(data).filter("div"); 
                console.log($data);               
                $(".world-news .post-preview-detailed").each(function (index, element) {
                    var elem = $(element);
                    elem.html($data.eq(index).html());
                });

                if (!interval_id)
                    interval_id = setInterval(slideThroughList, 6000);
            }
        });
        $.ajax({
            url: '/index.php?controller=posts&action=getByCategory',
            type: 'GET',
            data: "category=World&count=9",
            success: function (data) {
                $data = $(data).filter("div"); 
                console.log($data);               
                $(".world-news .post-preview").each(function (index, element) {
                    var elem = $(element);
                    elem.html($data.eq(index).html());
                });

                if (!interval_id)
                    interval_id = setInterval(slideThroughList, 6000);
            }
        });
    }

    //main
    loadSliderAsync();
    loadWorldAsync();
});